#!/bin/bash

echo "add ids"
uv run add-attributes -g "./data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"
uv run add-attributes -g "./data/meta/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"
uv run add-attributes -g "./data/indices/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"

echo "denormalize indices"
uv run denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml" -x ".//tei:title[@type='num']/text()"

echo "remove noteGrps from index entries in editions"
uv run  pyscripts/rm_notegrps.py