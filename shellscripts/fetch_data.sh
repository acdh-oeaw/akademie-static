#!/bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data/ && mkdir data
curl -LO https://github.com/fun-with-editions/akademie-data/archive/refs/heads/main.zip
unzip main

mv ./akademie-data-main/data/editions/ ./data
mv ./akademie-data-main/data/indices/ ./data
mv ./akademie-data-main/data/meta/ ./data

rm main.zip
rm -rf ./akademie-data-main
./shellscripts/dl_imprint.sh
