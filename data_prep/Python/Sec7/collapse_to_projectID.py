# collapse_to_projectID.py
# Compress dataset to per-project basis.
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

import sys

class informal(object):
    """A simple class to hold an informal consultation record."""
    def __init__(self, line):
        super(informal, self).__init__()
        self.line = line
        self.data = self.line.rstrip().split("\t")
        self.code = self.data[3]
        self.spp = self.data[13]
        self.biopsp = self.data[31]
        self.take = self.data[35]
        self.actwork = self.data[36]
        self.actcat = self.data[37]

def main():
    """Compress database to per-project basis.
    
    USAGE:
        python collapse_to_projectID.py <infile>
    ARGS:
        infile, path to a tab'd, clean version of the informal Sec7 database
    """
    process_infile()

def process_infile():
    "Return a dict of form projID: {<fields...>}"
    cur_id = ""
    for line in open(infile):
        if not line.startswith("Lead"):
            rec = informal(line)
            if cur_id == "":
                cur_id = rec.code
                new = rec.data
                new[13] = set([new[13]])
                new[31] = set([new[31]])
                new[35] = set([new[35]])
                new[36] = set([new[36]])
                new[37] = set([new[37]])
            elif cur_id == rec.code:
                new[13].add(rec.spp)
                new[31].add(rec.biopsp)
                new[35].add(rec.actwork)
                new[36].add(rec.actwork)
                new[37].add(rec.actcat)
            else:
                tmp_write(new)
                cur_id = rec.code
                new = rec.data
                new[13] = set([new[13]])
                new[31] = set([new[31]])
                new[35] = set([new[35]])
                new[36] = set([new[36]])
                new[37] = set([new[37]])
        else:
            print line.rstrip()
    tmp_write(new)

def tmp_write(new):
    new[13] = "|".join(new[13])
    new[31] = "|".join(new[31])
    new[35] = "|".join(new[35])
    new[36] = "|".join(new[36])
    new[37] = "|".join(new[37])
    newl = "\t".join(new)
    print newl

if __name__ == '__main__':
    infile = sys.argv[1]
    main()