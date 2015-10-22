# sec7_summary_stats.py
# Run through some summary stats in Python b/c R is terrible.
# Copyright (C) 2014 Jacob Malcom, jacob.w.malcom@gmail.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

import os
import sys

def main():
    """Run through some summary stats in Python b/c R is terrible.
    
    USAGE
        python sec7_summary_stats.py
    ARGS
        infile, path to the input file to be processed
    """
    res = {"Region": {}, "Office": {}}
    for line in open(infile):
        if line.startswith("Lead ") and not header:
            head = line
        elif line.startswith("Lead ") and header:
            print line
            if len(line.rstrip().split("\t")) != tot_len:
                print "Different headers!!!"
                print head.rstrip()
                print line.rstrip()
                sys.exit(1)
        else:
            data = line.rstrip().split("\t")
            data = clean_quotes(data)
            if len(data) < tot_len:
                # print len(data)
                delta = tot_len - len(data)
                rep = delta * [""]
                data.extend(rep)
                # print len(data)
                out.write("\t".join(data) + "\n")
            elif len(data) > tot_len:
                print "Line too long!"
                print len(data), ">", tot_len
                sys.exit(1)
            else:
                out.write(line)

def clean_quotes(d):
    return [x.replace('"', '') for x in d]



