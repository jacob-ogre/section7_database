# homogenize_species_names.py
# Convert Sec7 names to the standard names file from expenditures.
# Copyright (C) 2015 Defenders of Wildlife, jmalcom@defenders.org
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
from pprint import pprint as pp
from species_names import StandardNames as SN
from species_names import LookupNames as look
from section7 import Record

oddballs = {'eastern puma (=cougar) (puma (=felis) concolor couguar)':
                'Puma (=cougar), eastern|(Puma (=Felis) concolor cougar)', 
            'hayun iagu (=(guam), tronkon guafi (rota)) (serianthes nelsonii)':
                'Iagu, hayun (=(guam), tronkon guafi (rota))|(Serianthes nelsonii)',
            'ione (incl. irish hill) buckwheat (eriogonum apricum (incl. var. prostratum)':
                'Buckwheat, Ione (incl. Irish Hill)|(Eriogonum apricum (incl. var. prostratum))',
            'puma (=mountain lion) (puma (=felis) concolor (all subsp. except coryi)':
                'Puma (=mountain lion)|(Puma (=Felis) concolor (all subsp. except coryi))', 
            'robust (incl. scotts valley) spineflower (chorizanthe robusta (incl. vars. robusta and hartwegii)':
                'Spineflower, robust (incl. Scotts Valley)|Chorizanthe robusta (incl. vars. robusta and hartwegii))',
            'robust (incl. scotts valley) spineflower (chorizanthe robusta (incl. vars. robusta and hartwegii))':
                'Spineflower, robust (incl. Scotts Valley)|Chorizanthe robusta (incl. vars. robusta and hartwegii))',
            'san clemente island lotus (=broom) (acmispon dendroideus var. traskiae (=lotus d. ssp. traskiae)':
                'Lotus, San Clemente Island|Acmispon dendroideus var. traskiae (=Lotus d. ssp. traskiae))',
            'atlantic sturgeon (gulf subspecies) (acipenser oxyrinchus (=oxyrhynchus) desotoi)': 
                'Sturgeon, Atlantic (Gulf subspecies)|Acipenser oxyrinchus (=oxyrhynchus) desotoi'
            }

def main():
    """Homogenize species names in TAILS db.

    USAGE:
        python homogenize_species_names.py <infile> <stdfil> <outfil>

    ARGS:
        infile, path to tab'd file of not-quite-final prepped TAILS data
        stdfil, path to table of standardized names
        outfil, path to tab'd file of TAILS data with spp_ev_ls names cleaned
    """
    lookup = look(stdfil)
    too_many_parenth = set()
    with open(outfil, 'w') as out:
        for line in open(infile):
            if not line.startswith("activity_code"):
                rec = Record(line)
                too_many_parenth = too_many_parenth.union(rec.too_many_parentheses)
                new_names = []
                for i in rec.name_dict:
                    if i == "=(guam":
                        new_name = oddballs["hayun iagu (=(guam), tronkon guafi (rota)) (serianthes nelsonii)"]
                    else:
                        cur_sci = i[0].upper() + i[1:]
                        cur_name = lookup.find_by_scientific(cur_sci)
                        if len(rec.too_many_parentheses) > 0:
                            new_name = oddballs[list(rec.too_many_parentheses)[0]]
                        if cur_name != "No match":
                            new_name = cur_name.common + "|(" + cur_name.sci + ")"
                        else:
                            new_name = make_new_name(i, rec.name_dict[i])
                    new_names.append(new_name)
                rec.data[37] = "...".join(new_names)
                out.write(rec.make_new_line())
            else:
                out.write(line)

def make_new_name(sci, com):
    """Reorder common name, format sci name, and then add to names list.
    I may regret this function one day because it's 'cute' coding..."""
    new_sci = sci[0].upper() + sci[1:]
    com_parts = com.split(" ")
    new_com_grp = com_parts[-1][0].upper() + com_parts[-1][1:]
    new_com_spc = " ".join(com_parts[:-1])
    # try:
    #     new_com_grp = com_parts[-1][0].upper() + com_parts[-1][1:]
    # except:
    #     new_com_grp = "None"
    # try:
    #     new_com_spc = " ".join(com_parts[:-1])
    # except:
    #     new_com_spc = "None"
    new_com = new_com_grp + ", " + new_com_spc
    new_name = new_com + "|(" + new_sci + ")"
    return new_name


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    stdfil = sys.argv[2]
    outfil = sys.argv[3]
    main()
