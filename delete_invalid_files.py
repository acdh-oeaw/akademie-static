import csv
import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
print(f"selected {len(files)}")

faulty = []
for x in tqdm(files, total=len(files)):
    try:
        doc = TeiReader(x)
    except Exception as e:
        faulty.append([x, e])
        continue
    body = doc.any_xpath('//tei:body')[0]
    ET.strip_tags(body, '{http://www.tei-c.org/ns/1.0}w', '{http://www.tei-c.org/ns/1.0}pc')
    doc.tree_to_file(x)

with open('faulty.csv', 'w', newline='') as csvfile:
    my_writer = csv.writer(csvfile, delimiter=',')
    my_writer.writerow(['path', 'error'])
    for x in faulty:
        my_writer.writerow([x[0], x[1]])

for x in faulty:
    new = x[0].replace('.xml', '.faulty')
    os.remove(x[0])

print(f"deleted {len(faulty)}, see `faulty.csv` for a list of invalid files")