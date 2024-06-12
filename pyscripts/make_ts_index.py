import glob
import os

from typesense.api_call import ObjectNotFound

from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm
from datetime import datetime



files = glob.glob("./data/editions/*.xml")


current_schema = {
    "name": "akademie-static",
    "fields": [
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {
            "name": "jahr",
            "type": "int32",
            "optional": True,
            "facet": True,
        },
        {"name": "datum", "type": "string", "sort": True},
        {"name": "personen", "type": "string[]", "facet": True, "optional": True},
        {"name": "orte", "type": "string[]", "facet": True, "optional": True},
        {"name": "sitzungsrahmen", "type": "string", "facet": True, "optional": True},
    ],
    "default_sorting_field": "datum",
}

try:
    client.collections["akademie-static"].delete()
except ObjectNotFound:
    pass


client.collections.create(current_schema)


def get_entities(ent_type, ent_node, ent_name):
    entities = []
    e_path = f'.//tei:rs[@type="{ent_type}"]/@ref'
    for p in body:
        ent = p.xpath(e_path, namespaces={"tei": "http://www.tei-c.org/ns/1.0"})
        ref = [ref.replace("#", "") for e in ent if len(ent) > 0 for ref in e.split()]
        for r in ref:
            p_path = f'.//tei:{ent_node}[@xml:id="{r}"]//tei:{ent_name}[1]'
            en = doc.any_xpath(p_path)
            if en:
                if ent_name == 'persName':
                    # get forename(s) and surname
                    forenames = [" ".join(forename.text.split()) for forename in en[0].xpath(".//tei:forename", namespaces={"tei": "http://www.tei-c.org/ns/1.0"}) if forename.text is not None]
                    surnames = en[0].xpath(".//tei:surname", namespaces={"tei": "http://www.tei-c.org/ns/1.0"})
                    surname = surnames[0].text if surnames and surnames[0].text is not None else ''
                    if forenames:
                        if len(forenames) > 1:
                            if 'de' in forenames:
                                forenames = [forename for forename in forenames if forename != 'de']
                                forenames.append('de')
                            elif 'le' in forenames:
                                forenames = [forename for forename in forenames if forename != 'le']
                                forenames.append('le')
                            else:
                                print(forenames)
                        entity = surname + ', ' + ' '.join(forenames)
                    else:
                        entity = surname
                else:
                    entity = " ".join(" ".join(en[0].xpath(".//text()")).split())
                
                if len(entity) != 0:
                    entities.append(entity)
                else:
                    with open("log-entities.txt", "a") as f:
                        f.write(f"{r} in {record['id']}\n")
    return [ent for ent in sorted(set(entities))]

# recursively process lb hyphens
def join_without_hyphens(text_list):
    if len(text_list) < 2:
        return ' '.join(text_list)
    elif text_list[0].endswith('-') and text_list[1][0].islower():
        return join_without_hyphens([text_list[0][:-1] + text_list[1]] + text_list[2:])
    else:
        return text_list[0] + ' ' + join_without_hyphens(text_list[1:])

records = []
cfts_records = []

#files to exclude
exclude_files = ["./data/editions/A_0150.xml"]

for xml_file in tqdm([f for f in files if f not in exclude_files], total=len(files)):
    doc = TeiReader(xml=xml_file)

    # information on document level
    r_title = " ".join(" ".join(doc.any_xpath('.//tei:titleStmt/tei:meeting//text()')).split())
    if os.path.basename(xml_file).startswith("A"):
        series = "Gesamtakademie"
    elif os.path.basename(xml_file).startswith("C"):
        series = "philosophisch-historische Klasse"
    
    date_str = doc.any_xpath("//tei:titleStmt/tei:meeting/tei:date/@when")[0]
    # Check if date_str matches the ISO date format
    iso_date = None
    try:
        datetime.strptime(date_str, '%Y-%m-%d')
        iso_date = date_str
    except ValueError:
        print(xml_file)
    outer_body = doc.any_xpath(".//tei:body")[0]
    text_nodes = outer_body.xpath('.//text()[not(ancestor::tei:abbr) and not(self::text()[contains(.,"-") and following-sibling::tei:lb[1]])]', namespaces={"tei": "http://www.tei-c.org/ns/1.0"})
    facs = doc.any_xpath(".//tei:body/tei:div/tei:pb/@facs")
    pages = 0
    for v in facs:
        p_group = f".//tei:body/tei:div/tei:div[preceding-sibling::tei:pb[1]/@facs='{v}']/tei:p|.//tei:body/tei:div/tei:div[preceding-sibling::tei:pb[1]/@facs='{v}']/tei:lg"
        body = doc.any_xpath(p_group)
        
        pages += 1
        cfts_record = {"project": "akademie-static",}
        record = {}
        record["id"] = os.path.split(xml_file)[-1].replace(".xml", f".html#pag{str(pages)}")
        cfts_record["id"] = record["id"]
        cfts_record["resolver"] = (
                f"https://fun-with-editions.github.io/akademie-static/{record['id']}"
            )
        record["rec_id"] = os.path.split(xml_file)[-1]
        cfts_record["rec_id"] = record["rec_id"]

        record["title"] = f"{r_title} Seite {str(pages)}"
        cfts_record["title"] = record["title"]
        
        if iso_date is not None:
            record["datum"] = iso_date
            record["jahr"] = int(iso_date[:4])
            cfts_record["jahr"] = record["jahr"]
        
        record["sitzungsrahmen"] = series

        if len(body) > 0:
            # get unique persons per doc
            ent_type = "person"
            ent_name = "persName"
            record["personen"] = get_entities(
                ent_type=ent_type, ent_node=ent_type, ent_name=ent_name
                )
            cfts_record["personen"] = record["personen"]
            # get unique places per doc
            ent_type = "place"
            ent_name = "placeName"
            record["orte"] = get_entities(ent_type=ent_type, ent_node=ent_type, ent_name=ent_name)
            cfts_record["orte"] = record["orte"]

            #extract full text, excluding lb hyphens and abbreviations
            full_text = []
            for p in body:
                # Iterate through all text nodes within the <p> element excluding those within <abbr>
                for node in p.xpath('.//text()[not(ancestor::tei:abbr)]', namespaces={"tei": "http://www.tei-c.org/ns/1.0"}):
                    full_text.append(node)
            node = ' '.join(node.replace('\n', ' ').split())
            if node:  # Only append non-empty strings
                full_text.append(node)
            record["full_text"] = join_without_hyphens(full_text)
            if len(record["full_text"]) > 0:
                records.append(record)
                cfts_record["full_text"] = record["full_text"]
                cfts_records.append(cfts_record)

make_index = client.collections["akademie-static"].documents.import_(records,{"action": "upsert"})
errors = [msg for msg in make_index if (msg != '"{\\"success\\":true}"' and msg != '""')]
if errors:
    for err in errors:
        print(err)
else:
    print("\nno errors")
print("done with indexing Akademieprotokolle")

#make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
#print(make_index)
#print("done with cfts-index Akademieprotokolle")