import sys

infile = sys.argv[1]
for line in open(infile):
    if len(line.rstrip().split("\t")) < 50:
        print line
