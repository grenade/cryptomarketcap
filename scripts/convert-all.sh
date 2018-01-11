#!/bin/bash

for csv in $(find ./data -type f -name "*.csv"); do
  ./scripts/csv2json.sh ${csv} > "${csv%.*}.json"
  echo "${csv} converted to ${csv%.*}.json"
done
