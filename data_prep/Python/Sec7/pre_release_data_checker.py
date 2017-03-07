# -*- coding: utf-8 -*-
# Checks the "final" section 7 data relative to the original.
# Copyright © 2015 Defenders of Wildlife, jmalcom@defenders.org   

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

import gzip
from pprint import pprint as pp
import sys

class Record(object):
    """docstring for Record"""
    def __init__(self, line):
        super(Record, self).__init__()
        self.line = line
        self.data = self.line.rstrip().split("\t")
        self.region = self.data[0]
        self.ESFO = self.data[1]
        self.act_code = self.data[3]
        self.name = self.data[4]
        self.agency = self.data[8]
        self.sp = self.data[13]

class FinRec(object):
    """docstring for FinRec"""
    def __init__(self, line):
        super(FinRec, self).__init__()
        self.line = line
        self.data = self.line.rstrip().split("\t")
        if len(self.data) > 1:
            self.act_code = self.data[0]
            self.region = self.data[1]
            self.ESFO = self.data[2]
            self.name = self.data[4]
            self.agency = self.data[6]
        else:
            self.act_code = "None"
            self.region = "None"
            self.ESFO = "None"
            self.name = "None"
            self.agency = "None"


def main():
    orig = {}
    with open(namefil, 'w') as out:
        for line in gzip.open(infile):
            rec = Record(line)
            if rec.act_code not in orig:
                orig[rec.act_code] = rec
            if "Oncorhynchus" in rec.sp or "Salvelinus" in rec.sp:
                out.write("\t".join([rec.act_code, rec.sp]) + "\n")
            
    fin_acts = set()
    for line in open(final):
        rec = FinRec(line)
        fin_acts.add(rec.act_code)
        if rec.act_code not in orig:
            # print "Final not in original:", rec.act_code, rec.name
            continue
        if rec.agency.lower() != orig[rec.act_code].agency.lower():
            if not rec.agency.startswith(orig[rec.act_code].agency):
                print "Final and original agencies differ:", rec.act_code, \
                        rec.agency, orig[rec.act_code].agency
            else:
                print "Final agency extended:", rec.act_code, rec.agency, \
                        orig[rec.act_code].agency
        if rec.region != orig[rec.act_code].region:
            print "Final and original regions differ:", rec.act_code, \
                    rec.region, orig[rec.act_code].region
        

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    final = sys.argv[2]
    namefil = sys.argv[3]
    main()


