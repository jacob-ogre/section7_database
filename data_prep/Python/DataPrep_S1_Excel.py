# Read Section 7 Excel files and convert cleanly to tab'd files.
# Copyright (C) 2015 Defenders of Wildlife, jmalcom@defenders.org

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
import re
import sys
import xlrd

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
          "DEPT OF VETERANS AFFAIRS": "Department of Veterans Affairs"
          }

class Record(object):
    """Basic class to hold a Sec7 record from Excel workbook."""
    def __init__(self, row, dmod):
        "row = an xlrd row; dmod = the datemode of the workbook"
        super(Record, self).__init__()
        self.row = row
        self.region = str(int(self.row[0].value))
        self.ESFO = self.row[1].value
        self.FY = str(int(self.row[2].value))
        self.ID = self.row[3].value
        self.title = self.row[4].value.replace("\t", "t")
        self.act_type = self.row[5].value
        self.status = self.row[6].value
        self.ARRA = self.row[7].value
        self.lead_agency = self.row[8].value
        if self.lead_agency in AGENCY:
            self.lead_agency = AGENCY[self.lead_agency]
        self.lead_staff = self.row[9].value
        self.start_date = self.get_date(self.row[10].value, dmod)
        self.due_date = self.get_date(self.row[11].value, dmod)
        self.concl_date = self.get_date(self.row[12].value, dmod)
        self.spp_eval = self.row[13].value
        self.support_staff = self.row[14].value
        self.support_agency = self.row[15].value
        if self.support_agency in AGENCY:
            self.support_agency = AGENCY[self.support_agency]
        self.FY_start = str(int(self.row[16].value))
        if self.row[17].value != "":
            self.FY_end = str(int(self.row[17].value))
        else:
            self.FY_end = ""
        self.active, self.concl_date_2 = self.parse_active_field(self.row[18].value)
        self.timely = self.row[19].value
        if self.row[20].value != "":
            self.n_days = str(int(self.row[20].value))
        else:
            self.n_days = ""
        try:
            self.days_due = str(int(self.row[21].value))
        except:
            self.days_due = ""
        self.staff_hrs = self.row[22].value
        self.events = self.row[23].value
        self.no_more = self.row[24].value
        self.formal = self.row[25].value
        self.consult_type = self.row[26].value
        self.consult_complex = self.row[27].value
        self.formal_date = self.get_date(self.row[28].value, dmod)
        self.withdraw = self.row[29].value
        self.BO_species = self.row[30].value
        self.BO_conclusion = self.row[31].value
        self.CH_conclusion = self.row[32].value
        self.CH_flag = self.row[33].value
        self.take = re.sub('[^a-zA-Z0-9\n\.]', ' ', str(self.row[34].value))
        self.work_type = self.row[35].value.lower()
        self.work_category = self.get_work_cat(self.work_type)
        self.report_category = self.row[36].value
        self.datum = self.row[37].value
        self.lat = str(self.row[38].value)
        self.long = str(self.row[39].value)
        self.lat_deg = str(self.row[40].value)
        self.lat_min = str(self.row[41].value)
        self.lat_sec = str(self.row[42].value)
        self.long_deg = str(self.row[43].value)
        self.long_min = str(self.row[44].value)
        self.long_sec = str(self.row[45].value)
        self.UTME = str(self.row[46].value)
        self.UTMN = str(self.row[47].value)
        self.UTMzone = str(self.row[48].value)

        self.new_lis = [self.region, self.ESFO, self.FY, self.ID, self.title, 
                        self.act_type, self.status, self.ARRA, self.lead_agency, 
                        self.lead_staff, self.start_date, self.due_date, self.concl_date,
                        self.spp_eval, self.support_staff, self.support_agency,
                        self.FY_start, self.FY_end, self.active, self.concl_date_2,
                        self.timely, self.n_days, self.days_due, self.staff_hrs,
                        self.events, self.no_more, self.formal, self.consult_type,
                        self.consult_complex, self.formal_date, self.withdraw,
                        self.BO_species, self.BO_conclusion, self.CH_conclusion,
                        self.CH_flag, self.take, self.work_type,
                        self.work_category, self.report_category, self.datum,
                        self.lat, self.long, self.lat_deg, self.lat_min,
                        self.lat_sec, self.long_deg, self.long_min, self.long_sec,
                        self.UTMN, self.UTME, self.UTMzone]

        for i in range(len(self.new_lis)):
            self.new_lis[i] = self.new_lis[i].replace("#", "Num.").replace('"', '').replace("'", "")
        self.newline = "\t".join(self.new_lis)

    def get_date(self, val, dmod):
        "Return YEAR-MO-DA string given the xldate in val and the WB datemode."
        try:
            date = xlrd.xldate_as_tuple(val, dmod)
            return str(date[0]) + "-" + str(date[1]) + "-" + str(date[2])
        except:
            return ""

    def parse_active_field(self, val):
        "Return a clean text version of a date in val."
        data = val.split(" ")
        d = data[1]
        if "/" in d:
            split = d.split("/")
            if len(split[-1]) == 2 and int(split[-1]) < 50:
                split[-1] = "20" + split[-1]
            elif len(split[-1]) == 2 and int(split[-1]) >= 50:
                split[-1] = "19" + split[-1]
            date = "-".join([split[-1], split[0], split[1]])
        elif "-" in d:
            date = d
        else:
            date = "1990-01-01"
        return data[0], date

    def get_work_cat(self, x):
        return x.split(" - ")[0]

    def _is_float(self, x):
        try:
            float(x)
            return True
        except:
            return False

class Header(object):
    """Simple class to parse the header line of an Excel."""
    def __init__(self, row, ncol):
        super(Header, self).__init__()
        self.row = row
        self.new_lis = []
        for i in range(18):
            self.new_lis.append(self.row[i].value)
        self.new_lis.append("Active")
        self.new_lis.append("Active Conclusion Date")
        for i in range(19, 35):
            self.new_lis.append(self.row[i].value)
        self.new_lis.append("Work Category")
        self.new_lis.append("Work Type")
        for i in range(36, ncol):
            self.new_lis.append(self.row[i].value)
        self.header = "\t".join(self.new_lis)

def main():
    """Read Excel file(s) from Sec7 database and write to tab'd output.

    USAGE:
        DataPrep_S1_Excel.py <infiles...>
    ARGS:
        infiles, path to one or more Excel files from TAILS db.
    """
    header = False
    for fil in infiles:
        header = process_file(fil, header)

def process_file(f, h):
    "Process Excel file f to produce the equivalent tab'd file."
    wb = xlrd.open_workbook(f)
    sheets = wb.sheet_names()
    sheet = wb.sheet_by_name(sheets[0])
    nrows = sheet.nrows
    ncols = sheet.ncols
    for i in range(nrows):
        cur_row = sheet.row(i)
        if cur_row[0].value == "Lead Region" and h == False:
            print Header(cur_row, ncols).header
            h = True
        elif cur_row[0].value == "Lead Region" and h != False:
            pass
        else:
            print Record(cur_row, wb.datemode).newline
    return h


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print main.__doc__
        sys.exit(1)
    infiles = sys.argv[1:]
    main()

