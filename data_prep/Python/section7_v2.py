# section7.py
# A simple class to handle section 7 db records.
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

class Record(object):
    """NOTE: This class is incomplete, and focused only on species
       names at this time.
    """
    def __init__(self, line):
        super(Record, self).__init__()
        self.ignore_list = ["no species present", "invasive species",
                            "migratory birds trust resources", "", 
                            "no species defined", "interjurisdictional fish"]
        self.line = line.replace('")', '').replace('"', '')
        self.data = self.line.rstrip().split("\t")
        self.spp_ev = self.data[36].lower()
        self.spp_BO = self.data[37].lower()
        if ";" in self.spp_ev:
            self.ev_list = self.spp_ev.split("; ")
        else:
            self.ev_list = self.split_spp_ev_alt()
        self.get_name_parts()

    def split_spp_ev_alt(self):
        self.clean_1 = self.spp_ev.replace("c(", "")
        self.clean_2 = self.clean_1.replace(", =", " or =")
        return self.clean_2.split(", ")

    def get_name_parts(self):
        self.name_dict = {}
        self.too_many_parentheses = set()
        for i in self.ev_list:
            num_paren = i.count("(")
            if num_paren == 0:
                continue
            elif num_paren == 1:
                cur_spl = i.split(" (")
                com, sci = cur_spl[0], cur_spl[1].replace(")", "")
                self.name_dict[sci] = com
            elif num_paren == 2:
                self.parse_two_paren_pairs(i)
            else:
                self.too_many_parentheses.add(i)

    def _find_indices(self, s, x):
        "Return a list of index position of all char x in string s."
        return [i for i, ltr in enumerate(s) if ltr == x]
     
    def parse_two_paren_pairs(self, i):
        open_idx = self._find_indices(i, "(")
        close_idx = self._find_indices(i, ")")
        if open_idx[1] < close_idx[0]:
            com = i[:(open_idx[0] - 1)]
            sci = i[(open_idx[0] + 1):-1]
            self.name_dict[sci] = com
        else:
            com = i[:(open_idx[1] - 1)]
            sci = i[(open_idx[1] + 1):-1]
            self.name_dict[sci] = com

    def make_new_line(self):
        return "\t".join(self.data) + "\n"


