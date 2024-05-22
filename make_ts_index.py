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
    ],
    "default_sorting_field": "datum"
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
                entity = " ".join(" ".join(en[0].xpath(".//text()")).split())
                if len(entity) != 0:
                    entities.append(entity)
                else:
                    with open("log-entities.txt", "a") as f:
                        f.write(f"{r} in {record['id']}\n")
    return [ent for ent in sorted(set(entities))]


records = []
cfts_records = []
for xml_file in tqdm(files, total=len(files)):
    doc = TeiReader(xml=xml_file)
    """
    facs = doc.any_xpath(".//tei:body/tei:div/tei:pb/@facs")
    pages = 0
    for v in facs:
        p_group = f".//tei:body/tei:div/tei:div[preceding-sibling::tei:pb[1]/@facs='{v}']"
        body = doc.any_xpath(p_group)
        print (body)
        pages += 1
    """
    body = doc.any_xpath(".//tei:body")[0]
    # make record for each document, removed indent for the following lines
    cfts_record = {"project": "akademie-static",}
    record = {}
    #record["id"] = os.path.split(xml_file)[-1].replace(".xml", ".html")
    record["id"] = os.path.splitext(os.path.split(xml_file)[-1])[0]
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = (
            f"https://fun-with-editions.github.io/akademie-static/{record['id']}"
        )
    record["rec_id"] = os.path.split(xml_file)[-1]
    cfts_record["rec_id"] = record["rec_id"]
    r_title = " ".join(" ".join(doc.any_xpath('.//tei:titleStmt/tei:meeting//text()')).split())
    #record["title"] = f"{r_title} Page {str(pages)}"
    record["title"] = f"{r_title}"
    cfts_record["title"] = record["title"]
    date_str = doc.any_xpath("//tei:titleStmt/tei:meeting/tei:date/@when")[0]
    # Check if date_str matches the ISO date format
    try:
        datetime.strptime(date_str, '%Y-%m-%d')
        record["datum"] = date_str
        cfts_record["datum"] = date_str
        record["jahr"] = int(date_str[:4])
        cfts_record["jahr"] = int(date_str[:4])
    except ValueError:
        print(xml_file)


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
        text_nodes = body.xpath('.//text()[not(ancestor::tei:abbr) and not(self::text()[contains(.,"-") and following-sibling::tei:lb[1]])]', namespaces={"tei": "http://www.tei-c.org/ns/1.0"})
        record["full_text"] = ' '.join(node for node in text_nodes)
        #record["full_text"] = "\n".join(" ".join("".join(p.itertext()).split()) for p in body)
        if len(record["full_text"]) > 0:
            records.append(record)
            cfts_record["full_text"] = record["full_text"]
            cfts_records.append(cfts_record)

make_index = client.collections["akademie-static"].documents.import_(records,{"action": "upsert"})
print(make_index)
print("done with indexing Akademieprotokolle")

#make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
#print(make_index)
#print("done with cfts-index Akademieprotokolle")

