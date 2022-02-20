import glob
from slugify import slugify
from bs4 import BeautifulSoup
from tqdm import tqdm


source_file = './data/indices/listperson.xml'
with open(source_file) as fp:
    soup = BeautifulSoup(fp, 'xml')

replace_patterns = []
for x in soup.findAll("person"):
    old = x['xml:id']
    new = slugify(old)
    replace_patterns.append([old, new])
    x['xml:id'] = new
j = soup.findAll("person", {'xml:id': 'johann'})[-1]
j['xml:id'] = "johann_1"

with open(source_file, "w", encoding='utf-8') as fp:
    fp.write(str(soup))

source_file = './data/indices/listplace.xml'
with open(source_file) as fp:
    soup = BeautifulSoup(fp, 'xml')

for x in soup.findAll("place"):
    old = x['xml:id']
    new = slugify(old)
    replace_patterns.append([old, new])
    x['xml:id'] = new
j = soup.findAll("place", {'xml:id': 'varna'})[-1]
j['xml:id'] = "varna_1"

with open(source_file, "w", encoding='utf-8') as fp:
    fp.write(str(soup))

files = glob.glob('./data/editions/*.xml')
for file in tqdm(files, total=len(files)):
    with open(file) as cur_file:
         data = cur_file.read()
    for x in replace_patterns:
         data = data.replace(x[0], x[1])
    with open(file, "w") as cur_file:
         cur_file.write(data)