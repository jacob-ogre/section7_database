# -*- coding: utf-8 -*-
# Make text files of species lists for EPA vessel consultation.
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

import sys
from pprint import pprint as pp
from species_names import StandardNames as SN
from species_names import LookupNames as look

def main():
    """Make text files of species lists for EPA vessel consultation."""
    lookup = look(stdfil)
    names_ls = []
    cur_genus = ""
    for line in open(infile):
        if not line.startswith("Common Name"):
            data = line.rstrip().split("\t")
            try:
                com_name = lookup.find_by_scientific(data[1]).common
            except:
                continue
            try:
                names_ls.append(com_name + " (" + data[1] + ")")
            except:
                print "Not found:\n", data
    with open(spp_ev, 'w') as out:
        newl = "; ".join(names_ls)
        out.write(newl + "\n")
    with open(spp_BO, 'w') as out:
        newl = ": BO = Non-jeopardy / No Adverse Modification; CH = | ".join(names_ls)
        out.write(newl + "\n")
    print len(names_ls)



if __name__ == '__main__':
    if len(sys.argv) != 5:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    stdfil = sys.argv[2]
    spp_ev = sys.argv[3]
    spp_BO = sys.argv[4]
    main()
        
