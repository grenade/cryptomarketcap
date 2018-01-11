#!/bin/bash

mkdir -p ./data/dirty

n=$(wc -l ./data/coinlist.txt)
n=${n%% *}
i=0
while read -r coin; do
  if [ "" != "${coin}" ]; then
    i=$((i + 1))
    python ./scripts/coinmarketcap_usd_history.py ${coin} 2013-04-28 $(date +%Y-%m-%d) > ./data/dirty/${coin}.csv
    sed -i '1d' ./data/dirty/${coin}.csv
    r=$(wc -l ./data/dirty/${coin}.csv)
    r=${r%% *}

    # create clean, json convertable csv files (daily file for all coins and a file for each coin containing all days)
    while IFS=, read -r dt opn high low close vol mc avg; do
      dt=$(date -d"${dt}" +%Y%m%d)
      year=${dt:0:4}
      month=${dt:4:2}
      day=${dt:6:2}
      
      if [ ! -d ./data/usd ]; then
        mkdir -p ./data/usd
      fi
      if [ ! -d ./data/${year}/${month}/usd ]; then
        mkdir -p ./data/${year}/${month}/usd
      fi
      if [ ! -d ./data/${year}/${month}/${day}/usd ]; then
        mkdir -p ./data/${year}/${month}/${day}/usd
      fi
      if [ ! -f ./data/usd/${coin}.csv ]; then
        echo date,open,high,low,close,volume,marketcap,average > ./data/usd/${coin}.csv
      fi
      if [ ! -f ./data/${year}/${month}/${day}/usd/all.csv ]; then
        echo coin,date,open,high,low,close,volume,marketcap,average > ./data/${year}/${month}/${day}/usd/all.csv
      fi
      echo ${dt},${opn},${high},${low},${close},${vol//[\-]/},${mc//[\-]/},${avg} >> ./data/usd/${coin}.csv
      echo ${coin},${dt},${opn},${high},${low},${close},${vol//[\-]/},${mc//[\-]/},${avg} >> ./data/${year}/${month}/${day}/usd/all.csv
      
    done < ./data/dirty/${coin}.csv
    rm -f ./data/dirty/${coin}.csv
    echo "${i}/${n} ${coin} (${r} records imported)"
    
  fi
done < ./data/coinlist.txt
