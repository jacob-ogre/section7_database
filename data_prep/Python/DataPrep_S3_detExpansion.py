# Convert the BO determination fields to individual variables.
# Copyright (C) 2015 Defenders of Wildlife

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

import sys

def main():
    """Convert the BO determination fields to individual variables.
    
    USAGE:
        python DataPrep_S3_detExpansion <infile> <outfil> <BO_table> <CH_table>
    ARGS:
        infile, path to a tab-delimited file of TAILS database
        outfil, path to a tab'd file with BO determinations expanded
        BO_table, path to a tab'd file that translates TAILS BO determinations
        CH_table, path to a tab'd file that translates TAILS CH findings
    """
    BO_lookup = load_trans(BO_table)
    CH_lookup = load_trans(CH_table)
    parse_input(BO_lookup, CH_lookup)

def load_trans(f):
    """Return a dict of form field:new_fields."""
    res = {}
    for line in open(f):
        if not line.startswith("Database"):
            data = line.rstrip().split("\t")
            res[data[0]] = data[1:]
    return res

def parse_input(B, C):
    "Read infile and add new fields per BO and CW determination fields."
    nil = ["NA", "NA", "NA", "NA", "NA", "NA", "NA"]
    corrections = ["list of bad consultation IDs"]
    with open(outfil, 'wb') as out:
        for line in open(infile):
            if line.startswith("region"):
                data = line.rstrip().split("\t")
                head = data[:25]
                mid = ["NoEffect", "NLAA", "Concur", "Jeopardy", "RPA",
                       "AdvMod", "TechAssist"]
                head.extend(mid)
                head.extend(data[25:])
                out.write("\t".join(head) + "\n")
            else:
                data = line.rstrip().split("\t")
                head = data[:25]
                if data[25] in B:
                    new_BO = B[data[25]]
                elif data[25] == "":
                    new_BO = nil
                else:
                    print "Something awry in BO!"
                    print data[25]
                    sys.exit()
                if data[26] in C:
                    new_CH = C[data[26]]
                elif data[26] == "":
                    new_CH = nil
                else:
                    print "Something awry in CH!"
                    print data[26]
                    sys.exit()
                new_fields = reconcile(new_BO, new_CH)
                head.extend(new_fields)
                head.extend(data[25:])
                out.write("\t".join(head) + "\n")

def reconcile(B, C):
    "Return a list of seven elements reconcoling conflicts of B, C."
    new = []
    for i in range(len(B)):
        if B[i] != C[i]:
            if B[i] == "NA":
                new.append(C[i])
            elif B[i] == "0" and C[i] == "1":
                new.append(C[i])
            elif B[i] != "NA":
                new.append(B[i])
            elif B[i] == "1" and C[i] == "0":
                new.append(B[i])
            else:
                print B
                print C
                sys.exit()
        else:
            new.append(B[i])
    return new

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    BO_table = sys.argv[3]
    CH_table = sys.argv[4]
    main()

