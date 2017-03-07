# -*- coding: utf-8 -*-
# Make text files of species lists for FS fire retardant consultation.
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

jeopadmo = ": BO = Jeopardy / Adverse Modification with RPAs; CH = |"
jeop = ": BO = Jeopardy with RPAs; CH = |"
admo = ": BO = Adverse Modification with RPAs; CH = |"

def main():
    """Make text files of species lists for EPA vessel consultation."""
    lookup = look(stdfil)
    names_ls = []
    n_jeop, n_admo = 0, 0
    for line in open(infile):
        if not line.startswith("Common Name"):
            data = line.rstrip().split("\t")
            try:
                com_name = lookup.find_by_scientific(data[2]).common
            except:
                continue
            try:
                if data[3] == "Y" and data[4] == "Y":
                    names_ls.append(com_name + " (" + data[2] + ")" + jeopadmo)
                    n_jeop += 1
                    n_admo += 1
                elif data[3] == "Y":
                    names_ls.append(com_name + " (" + data[2] + ")" + admo)
                    n_admo += 1
                else:
                    names_ls.append(com_name + " (" + data[2] + ")" + jeop)
                    n_jeop += 1
            except:
                print "Not found:\n", data
    # with open(spp_ev, 'w') as out:
    #     newl = "; ".join(names_ls)
    #     out.write(newl + "\n")
    with open(spp_BO, 'w') as out:
        newl = " ".join(names_ls)
        out.write(newl + "\n")
    # pp(names_ls)
    print "# spp.", len(names_ls)
    print "# jeop", n_jeop 
    print "# admo", n_admo

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    stdfil = sys.argv[2]
    spp_ev = sys.argv[3]
    spp_BO = sys.argv[4]
    main()
        

