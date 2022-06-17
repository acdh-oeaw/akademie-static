# bin/bash
rm -rf tempdir && mkdir tempdir && rm dl.tar.gz
rm -rf ./data/editions && mkdir -p ./data/editions
rm -rf ./data/indices && mkdir -p ./data/indices

curl -H "Authorization: token ${GITLAB_TOKEN}" -L https://api.github.com/repos/dariok/gesamtakademie/tarball > dl.tar.gz
tar -xf dl.tar.gz -C tempdir && rm dl.tar.gz
python copy_files.py && rm -rf tempdir
echo "delete invalid files"
python delete_invalid_files.py
find ./data/editions/ -type f -name "*.xml"  -print0 | xargs -0 sed -i 's@ref="per:@ref="#@'
find ./data/editions/ -type f -name "*.xml"  -print0 | xargs -0 sed -i 's@ref="pla:@ref="#@'
find ./data/indices/ -type f -name "*person.xml"  -print0 | xargs -0 sed -i 's@place xml:id="place__@place key="place__@'

echo "slugify ids"
python slug_ids.py

echo "add ids"
add-attributes -g "./data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"
add-attributes -g "./data/meta/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"
add-attributes -g "./data/indices/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"

echo "denormalize indices"
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml" -x ".//tei:title[@type='num']/text()"

echo "build index.json"
python make_typesense_index.py