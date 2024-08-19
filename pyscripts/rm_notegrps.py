# by @csae8092, https://github.com/acdh-oeaw/staribacher-static/blob/main/pyscripts/rm_notegrps.py
import glob
from tqdm import tqdm
from acdh_tei_pyutils.tei import TeiReader

files = sorted(glob.glob("./data/editions/*.xml"))
print(f"removing noteGrp from {len(files)} edition files")

for x in tqdm(files, total=len(files)):
    try:
        doc = TeiReader(x)
    except:  # noqa
        continue
    for bad in doc.any_xpath(".//tei:back//tei:noteGrp"):
        bad.getparent().remove(bad)
    doc.tree_to_file(x)
