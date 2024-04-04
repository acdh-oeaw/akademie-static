#!/bin/bash

echo "add ids"
add-attributes -g "./data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"
add-attributes -g "./data/meta/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"
add-attributes -g "./data/indices/*.xml" -b "https://id.acdh.oeaw.ac.at/akademieprotokolle"

echo "denormalize indices"
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml" -x ".//tei:title[@type='num']/text()"