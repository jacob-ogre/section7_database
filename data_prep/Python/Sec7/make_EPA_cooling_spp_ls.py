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

oddballs = {'Charadrius melodus: Great Lakes': 'Charadrius melodus',
            'Charadrius melodus: Non-Great': 'Charadrius melodus',
            'N. crypticus': 'Noturus crypticus',
            'N. flavipinnis': 'Noturus flavipinnis',
            'N. placidus': 'Noturus placidus',
            'N. stanauli': 'Noturus stanauli',
            'N. trautmani': 'Noturus trautmani',
            'O. clarki stomias': 'Oncorhynchus clarki stomias',
            'O. clarkii henshawi': 'Oncorhynchus clarki henshawi',
            'O. clarkii seleniris': 'Oncorhynchus clarki seleniris',
            'R. osculus ssp.': 'Rhinichthys osculus ssp.',
            'Enhuydra lutris kenyoni': 'Enhydra lutris kenyoni',
            'E.l. nereis': 'Enhydra lutris nereis'}

def main():
    """Make text files of species lists for EPA vessel consultation."""
    lookup = look(stdfil)
    names_ls = []
    for line in open(infile):
        if not line.startswith("Common Name"):
            data = line.rstrip().split("\t")
            sci = data[1]
            if sci in oddballs:
                try:
                    com_name = lookup.find_by_scientific(oddballs[sci]).common
                except:
                    print data
                    continue
            else:
                sci_dat = sci.split(" ")
                genus = sci_dat[0]
                species = sci_dat[1]
                if sci_dat[0].endswith(".") and sci_dat[1].endswith("."):
                    sci_dat[0] = cur_genus
                    sci_dat[1] = cur_species
                    sci = " ".join(sci_dat)
                elif sci_dat[0].endswith("."):
                    sci_dat[0] = cur_genus
                    sci = " ".join(sci_dat)
                else:
                    cur_genus = genus
                    cur_species = species
                try:
                    com_name = lookup.find_by_scientific(sci).common
                except:
                    print data
                    continue
            try:
                names_ls.append(com_name + " (" + sci + ")")
            except:
                print "Not found:\n", data
    # with open(spp_ev, 'w') as out:
    #     newl = "; ".join(names_ls)
    #     out.write(newl + "\n")
    # with open(spp_BO, 'w') as out:
    #     newl = ": BO = Non-jeopardy / No Adverse Modification; CH = | ".join(names_ls)
    #     out.write(newl + "\n")
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
        
