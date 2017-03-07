# -*- coding: UTF-8 -*-
# Extract standard names and taxonomic groups to table for reference.
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

from expenditures import RefinedRecord 
import sys

def main():
    """Extract standard names and taxonomic groups to table for reference.

    USAGE:
        python sec7_species_to_groups.py <infile> <outfil>
    ARGS:
        infile, path to the refined 2008-2013 ESA expenditures file
        outfil, path to the output reference file, tab-delimited
    """
    res = {}
    for line in open(infile):
        rec = RefinedRecord(line)
        if rec.year != "Year":
            res[rec.sci] = [rec.group, rec.common, rec.comm_group, rec.comm_spec,
                            rec.sci, rec.genus, rec.species]
            
    with open(outfil, 'w') as out:
        for k in res:
            to_write = "\t".join(res[k]) + "\n"
            out.write(to_write)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()


