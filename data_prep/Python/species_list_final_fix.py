# -*- encoding: utf-8 -*-
# Trying to fix the salmonid naming problem...
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

from species_names import LookupNames
from pprint import pprint as pp
import sys

def main():
    """Find consults with salmonids and replace spp_ev_ls with correct names.

    USAGE:
        python species_list_final_fix.py <salmonf> <infile> <stdfil> <outfil>
    ARGS:
        salmonf, path to a tab'd file of activity_code, species from original
            data
        infile, path to a tab'd version of all TAILS data
        stdfil, path to the ESA standard names file
        outfil, path to the updated, tab'd TAILS data
    COMMENTS:
        For some reason, if a consultation had multiple salmonid species, then
        one or two of the species' names would be repeated while some species'
        names were dropped.  The species counts were correct, but the names 
        were not.  The result was that the number of consultations was 
        underestimated for the less-consulted salmonids and may have been over-
        estimated for the common species (although that's only a 'may'). This 
        script corrects those repeats by referencing the species evaluated in
        the original data from FWS (actually the first tab'd version of that
        data); dropping salmonids from the current data; then appending the 
        correct salmonid names to the other names for each problematic consult.
    """
    primary = {}
    for line in open(salmonf):
        data = line.rstrip().split("\t")
        if data[0] not in primary:
            primary[data[0]] = set([data[1]])
        else:
            primary[data[0]].add(data[1])
    
    part = []
    look = LookupNames(stdfil)
    with open(outfil, 'w') as out:
        for line in open(infile):
            data = line.rstrip().split("\t")
            if data[1] in primary:
                print "Old:\n\t", data
                current = data[35].split("; ")
                new_names = set()
                for i in current:
                    if "Oncorhynchus" not in i and "Salvelinus" not in i:
                        new_names.add(i)
                old_salmo = primary[data[1]]
                for i in old_salmo:
                    new_names.add(get_correct(i, look))
                new_ev_ls = "; ".join(new_names)
                data[35] = new_ev_ls 
                out.write("\t".join(data) + "\n")
                print "New:\n\t", data
            else:
                out.write(line)

def get_correct(i, look):
    common = i.split(" (")[0]
    if len(common.split(" ")) > 1:
        split = common.split(" ")
        common = split[-1] + ", " + " ".join(split[0:-1])
    sci = look.find_by_common(common)
    common = look.find_by_scientific(sci.sci)
    return common.common + " (" + sci.sci + ")"


if __name__ == '__main__':
    if len(sys.argv) != 5:
        print main.__doc__
        sys.exit()
    salmonf = sys.argv[1]
    infile = sys.argv[2]
    stdfil = sys.argv[3]
    outfil = sys.argv[4]
    main()

