# Summary overview of FWS formal Sec 7 consultations.
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

import os
import sys

AGENCY = {"DEPT OF AGRICULTURE": "Department of Agriculture",
          "DEPT OF COMMERCE": "Department of Commerce",
          "DEPT OF DEFENSE": "Department of Defense",
          "DEPT OF EDUCATION": "Department of Education",
          "DEPT OF ENERGY": "Department of Energy",
          "DEPT OF HEALTH AND HUMAN SERVICES": "Department of Health and Human Services",
          "DEPT OF HOMELAND SECURITY": "Department of Homeland Security",
          "DEPT OF HOUSING AND URBAN DEVELOPMENT": "Department of Housing and Urban Development",
          "DEPT OF INTERIOR": "Department of Interior",
          "DEPT OF JUSTICE": "Department of Justice",
          "DEPT OF LABOR": "Department of Labor",
          "DEPT OF STATE": "Department of State",
          "DEPT OF THE INTERIOR": "Department of Interior",
          "DEPT OF TRANSPORTATION": "Department of Transportation",
          "DEPT OF VETERANS AFFAIRS": "Department of Veterans Affairs"}

def main():
    """Summary overview of FWS informal Sec 7 consultations.
    
    USAGE:
        python informal_summaries.py <infile> <outfil>
    ARGS:
        infile, path to the input file to be processed
        outfil, path to the summary output file
    NOTES:
        For the sake of simplicity, any records where the active/concluded date 
        field was non-existent were set to 01 Jan 1990...that is not the actual
        date.
    """
    header = False
    head = ""
    tot_len = 0
    cnt = 0
    with open(outfil, 'wb') as out:
        for line in open(infile):
            cnt += 1
            if line.startswith("Lead ") and not header:
                data = line.rstrip().split("\t")
                data.insert(19, "Date Active/Concluded")
                newl = "\t".join(data) + "\n"
                out.write(newl)
                tot_len = len(line.rstrip().split("\t"))
                header = True
                head = line
            elif line.startswith("Lead ") and header:
                if len(line.rstrip().split("\t")) != tot_len:
                    print "Different headers!!!"
                    print head.rstrip()
                    print line.rstrip()
                    sys.exit(1)
            else:
                line = line.replace("#", "No.").replace('"', '').replace("'", "")
                data = line.rstrip().split("\t")
                if len(data) < tot_len:
                    delta = tot_len - len(data)
                    rep = delta * [""]
                    data.extend(rep)
                    data = clean_fields(data)
                    out.write("\t".join(data) + "\n")
                elif len(data) > tot_len:
                    print "Line too long!", cnt
                    print len(data), ">", tot_len
                    sys.exit(1)
                else:
                    data = clean_fields(data)
                    out.write("\t".join(data) + "\n")

def clean_fields(d):
    field = d[18].split(" ")
    date = field[-1]
    status = " ".join(field[:-1])
    d[18] = clean_date(date)
    d.insert(18, status)
    d[10] = clean_date(d[10])
    d[11] = clean_date(d[11])
    d[12] = clean_date(d[12])
    if d[8] in AGENCY:
        d[8] = AGENCY[d[8]]
    if d[15] in AGENCY:
        d[15] = AGENCY[d[15]]
    if d[16] == "1900":
        d[16] = "2000"
    if d[17] == "1009":
        d[17] = "2009"
    if d[29] != "":
        d[29] = "NA"
    return d

def clean_date(d):
    if "/" in d:
        split = d.split("/")
        if len(split[-1]) == 2 and int(split[-1]) < 50:
            split[-1] = "20" + split[-1]
        elif len(split[-1]) == 2 and int(split[-1]) >= 50:
            split[-1] = "19" + split[-1]
        return "-".join([split[-1], split[0], split[1]])
    elif "-" in d:
        return d
    else:
        # Using this as a placeholder for simplicity:
        return "1990-01-01"



if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit(1)
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()
    
