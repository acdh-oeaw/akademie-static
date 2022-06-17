import glob
import os
import ciso8601
import time
import typesense

from typesense.api_call import ObjectNotFound
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
TYPESENSE_API_KEY = os.environ.get("TYPESENSE_API_KEY")


client = typesense.Client({
  'nodes': [{
    'host': os.environ.get('TYPESENSE_HOST','localhost'), # For Typesense Cloud use xxx.a1.typesense.net
    'port': os.environ.get('TYPESENSE_PORT', '8108'),      # For Typesense Cloud use 443
    'protocol': os.environ.get('TYPESENSE_PROTOCOL', 'http')   # For Typesense Cloud use https
  }],
  'api_key': TYPESENSE_API_KEY,
  'connection_timeout_seconds': 120
})

try:
    client.collections['akademie-static'].delete()
except ObjectNotFound:
    pass

akademie_schema = {
    'name': 'akademie-static',
    'fields': [
        {
            'name': 'id',
            'type': 'string'
        },
        {
            'name': 'rec_id',
            'type': 'string'
        },
        {
            'name': 'title',
            'type': 'string'
        },
        {
            'name': 'full_text',
            'type': 'string'
        },
        {
            'name': 'date',
            'type': 'int64',
            'optional': True
        },
        {
            'name': 'year',
            'type': 'int32',
            'optional': True,
            'facet': True,
        },
        {
            'name': 'persons',
            'type': 'string[]',
            'facet': True,
            'optional': True
        },
        {
            'name': 'places',
            'type': 'string[]',
            'facet': True,
            'optional': True
        }
    ]
}

client.collections.create(akademie_schema)

records = []
for x in tqdm(files, total=len(files)):
    record = {}
    doc = TeiReader(x)
    body = doc.any_xpath('.//tei:body')[0]
    record['rec_id'] = os.path.split(x)[-1]
    record['id'] = os.path.split(x)[-1].replace('.xml', '')
    record['title'] = " ".join(" ".join(doc.any_xpath('.//tei:meeting[1]//text()')).split())
    date_str = doc.any_xpath('.//tei:date[1]/@when')[0]
    try:
        ts = ciso8601.parse_datetime(date_str)
    except ValueError:
        ts = ciso8601.parse_datetime('1800-01-01')
    try:
        record['year'] = int(date_str[:4])
    except ValueError:
        pass
    record['date'] = int(time.mktime(ts.timetuple()))
    record['persons'] = [
        " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:person/tei:persName')
    ]
    record['places'] = [
         " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:place[@xml:id]/tei:placeName')
    ]
    record['full_text'] = " ".join(''.join(body.itertext()).split())
    records.append(record)

make_index = client.collections['akademie-static'].documents.import_(records)
print('done indexing')
# print(make_index)

# with open('index.json', 'w', encoding="utf-8") as f:
#     json.dump(records, f, ensure_ascii=False)