# --*--encoding: utf-8--*--
# Finding more problem names in the database... 
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

from pprint import pprint as pp
import sys

def main():
    """Yet another attempt to get species names right for the sec7 app..."""
    to_change = load_to_change()
    # pp(to_change)
    with open(outfil, 'w') as out:
        for line in open(infile):
            if not line.startswith("activity_code"):
                data = line.rstrip().split("\t")
                species = data[36]
                spp_ls = species.split("; ")
                new_spp_ls = set()
                for i in range(len(spp_ls)):
                    if spp_ls[i] in to_change:
                        new_spp_ls.add(to_change[spp_ls[i]])
                    else:
                        new_spp_ls.add(spp_ls[i])
                new_spp = "; ".join(new_spp_ls)
                data[36] = new_spp
                new_line = "\t".join(data) + "\n"
                out.write(new_line)
            else:
                out.write(line)

def load_to_change():
    res = {}
    for line in open(keyfile):
        if not line.startswith("Current"):
            data = line.replace('"', '').rstrip().split("\t")
            res[data[0]] = data[1]
    return res


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print main.__doc__
        sys.exit()
    keyfile = sys.argv[1]
    infile = sys.argv[2]
    outfil = sys.argv[3]
    main()
