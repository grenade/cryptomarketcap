#!/bin/bash

for csv in $(find ./data -type f -name "*.csv"); do
  python ./scripts/csv2json.py -i ${csv} -o "${csv%.*}.json" -f pretty
  echo "${csv} converted to ${csv%.*}.json"
done
