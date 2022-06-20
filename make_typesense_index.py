import glob
import os
import ciso8601
import time

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')

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
cfts_records = []
for x in tqdm(files, total=len(files)):
    record = {}
    cfts_record = {
        'project': 'akademie-static',
    }
    doc = TeiReader(x)
    body = doc.any_xpath('.//tei:body')[0]
    record['rec_id'] = os.path.split(x)[-1]
    cfts_record['rec_id'] = record['rec_id']
    record['id'] = os.path.split(x)[-1].replace('.xml', '')
    cfts_record['id'] = record['id']
    record['title'] = " ".join(" ".join(doc.any_xpath('.//tei:meeting[1]//text()')).split())
    cfts_record['title'] = record['title']
    date_str = doc.any_xpath('.//tei:date[1]/@when')[0]
    try:
        ts = ciso8601.parse_datetime(date_str)
    except ValueError:
        ts = ciso8601.parse_datetime('1800-01-01')
    try:
        record['year'] = int(date_str[:4])
        cfts_record['year'] = record['year']
    except ValueError:
        pass
    record['date'] = int(time.mktime(ts.timetuple()))
    cfts_record['date'] = record['date']
    record['persons'] = [
        " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:person/tei:persName')
    ]
    cfts_record['persons'] = record['persons']
    record['places'] = [
         " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:place[@xml:id]/tei:placeName')
    ]
    cfts_record['places'] = record['places']
    record['full_text'] = " ".join(''.join(body.itertext()).split())
    cfts_record['full_text'] = record['full_text']
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections['akademie-static'].documents.import_(records)
print('done indexing')
print('done with indexing akademie-static')

make_index = CFTS_COLLECTION.documents.import_(cfts_records)
print(make_index)