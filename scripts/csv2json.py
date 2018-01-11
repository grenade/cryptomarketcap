#!/usr/bin/python

import sys, getopt, csv, json

def main(argv):
    input_file = ''
    output_file = ''
    format = ''
    try:
        opts, args = getopt.getopt(argv,"hi:o:f:",["ifile=","ofile=","format="])
    except getopt.GetoptError:
        print 'csv2json.py -i <path to inputfile> -o <path to outputfile> -f <dump/pretty>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'csv2json.py -i <path to inputfile> -o <path to outputfile> -f <dump/pretty>'
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_file = arg
        elif opt in ("-o", "--ofile"):
            output_file = arg
        elif opt in ("-f", "--format"):
            format = arg
    read_csv(input_file, output_file, format)

def read_csv(csv_file, json_file, format):
    rows = []
    with open(csv_file, 'rU') as csvfile:
        seen = set() # set for fast O(1) amortized lookup to remove duplicates
        reader = csv.DictReader(csvfile)
        title = reader.fieldnames
        for row in reader:
            if 'coin' in title:
                key = "{}{}".format(row['coin'], row['date'])
            else:
                key = row['date']
            if key in seen: continue # skip duplicate
            seen.add(key)
            rows.extend([{title[i]:row[title[i]] for i in range(len(title))}])
        write_json(rows, json_file, format)

def write_json(data, json_file, format):
    with open(json_file, "w") as f:
        if format == "pretty":
            f.write(json.dumps(data, sort_keys=False, indent=4, separators=(',', ': '),encoding="utf-8",ensure_ascii=False))
        else:
            f.write(json.dumps(data))

if __name__ == "__main__":
   main(sys.argv[1:])