import glob
import os
import shutil
from tqdm import tqdm
files = glob.glob('./tempdir/**/C_0*.xml', recursive=True)
target_dir = './data/editions/'
for x in tqdm(files, total=len(files)):
    head, tail = os.path.split(x)
    shutil.copyfile(x, f"{target_dir}{tail}")

files = glob.glob('./tempdir/**/A_0*.xml', recursive=True)
target_dir = './data/editions/'
for x in tqdm(files, total=len(files)):
    head, tail = os.path.split(x)
    shutil.copyfile(x, f"{target_dir}{tail}")


files = glob.glob('./tempdir/**/list*.xml', recursive=True)
target_dir = './data/indices/'
for x in tqdm(files, total=len(files)):
    head, tail = os.path.split(x)
    shutil.copyfile(x, f"{target_dir}{tail}")