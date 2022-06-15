import glob
import os

from acdh_tei_pyutils.tei import TeiReader
from algoliasearch.search_client import SearchClient
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
ALGOLIA_APP_ID = os.environ.get("ALGOLIA_APP_ID")
ALGOLIA_API_KEY = os.environ.get('ALGOLIA_API_KEY')

records = []
for x in tqdm(files, total=len(files)):
    record = {}
    doc = TeiReader(x)
    body = doc.any_xpath('.//tei:body')[0]
    record['rec_id'] = os.path.split(x)[-1]
    record['title'] = " ".join(" ".join(doc.any_xpath('.//tei:meeting[1]//text()')).split())
    record['date'] = doc.any_xpath('.//tei:date[1]/@when')[0]
    record['persons'] = [
        " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:person/tei:persName')
    ]
    record['places'] = [
         " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:place[@xml:id]/tei:placeName')
    ]
    record['full_text'] = " ".join(''.join(body.itertext()).split())
    records.append(record)

client = SearchClient.create(
    ALGOLIA_APP_ID,
    ALGOLIA_API_KEY
)

index = client.init_index('akademie-static')

index.save_objects(records, {
    'autoGenerateObjectIDIfNotExist': True
})