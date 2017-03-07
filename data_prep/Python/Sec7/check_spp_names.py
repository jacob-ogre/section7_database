# check_spp_names.py
# Use letter-wise counts to try to ID possible typos in Sec7 spp. list.
# Copyright (C) 2014 Jacob Malcom, jacob.w.malcom@gmail.com
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

import itertools
from pprint import pprint as pp
import string
import sys

def main():
    """Use letter-wise counts to try to ID possible typos in Sec7 spp. list.
    
    USAGE:
        python check_spp_names.py <infile>
    ARGS:
        infile, path to single-column file of spp. names from Sec7 table
    RETURNS:
        Prints to STDOUT any pairs of spp from the infile where the sum of 
        squared differences in the counts of all letters is < 5, which would be
        indicative of an off-by-one (or two) typo.
    """
    spp = load_spp()
    compare_distances(spp)

def load_spp():
    "Return a dict of form species: {a: count, ... z:count}."
    cnt = 0
    res = {}
    for line in open(infile):
        if cnt > 2:
            res[line.rstrip()] = lett_counts(line)
            cnt += 1
        else:
            cnt += 1
    return res

def lett_counts(l):
    "Return the dict of lowercase letter counts in string (line) l."
    a_dict = dict.fromkeys(string.lowercase, 0)
    name_lower = string.lower(l.rstrip())
    for i in name_lower:
        if i in string.lowercase:
            a_dict[i] += 1
    return a_dict

def compare_distances(s):
    "If two keys in dict s are highly similar, print keys and difference to STDOUT"
    for i, j in itertools.combinations(s.keys(), 2):

        # first check SSD of letter counts
        ssd = 0
        for lett in s[i].keys():
            ssd += (s[i][lett] - s[j][lett])**2
        if ssd <= 5:
            print "SSD: ", i, j, ssd

        # next check if one to three letters are switched
        if len(i) == len(j):
            hamming = 0
            for l in range(len(i)):
                if i[l] != j[l]:
                    hamming += 1
            if hamming < 4:
                print "Hamming: ", i, j, hamming




if __name__ == '__main__':
    infile = sys.argv[1]
    main()