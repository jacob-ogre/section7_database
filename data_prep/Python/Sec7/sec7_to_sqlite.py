# sec7_to_sqlite.py
# Loads the full Section 7 database from tab'd file to sqlite db.
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

import sqlite3 as lite
import sys

def main():
    """Loads the full Section 7 database from tab'd file to sqlite db.
    
    USAGE:
        python sec7_to_sqlite.py <infile> <db>
    ARGS:
        infile, path to a tab'd file of Section 7 data
        path_to_db, path to the databse to be created or modified
        table_name, name of table to be added
    """
    drop_state = "DROP TABLE IF EXISTS %s" % table_name
    make_table = """CREATE TABLE %s(region TEXT, ESOffice TEXT, FY TEXT, 
                    activity_code TEXT, title TEXT, activity_type TEXT,
                    status TEXT, ARRA TEXT, lead_agency TEXT, staff_lead TEXT,
                    start_date TEXT, due_date TEXT, FWS_concl_date TEXT, 
                    spp_eval TEXT, staff_support TEXT, support_agency TEXT, 
                    FY_start TEXT, FY_concl TEXT, active_concl TEXT, 
                    date_active_concl TEXT, timely_concl TEXT,
                    n_days_elapsed TEXT, n_days_due TEXT, hours_logged TEXT,
                    events_logged TEXT, no_FWS_performed TEXT, 
                    formal_consult TEXT, consult_type TEXT, 
                    consult_complex TEXT, date_formal_consult TEXT,
                    withdrawn TEXT, spp_BO TEXT, BO_determination TEXT,
                    CH_determination TEXT, CH_flag TEXT, take TEXT, 
                    work_type TEXT, work_category TEXT, performance TEXT, 
                    datum TEXT, lat_dec_deg TEXT, long_dec_deg TEXT, 
                    lat_deg TEXT, lat_min TEXT, lat_sec TEXT, long_deg TEXT, 
                    long_min TEXT, long_sec TEXT, UTM_E TEXT, UTM_N TEXT, 
                    UTM_zone TEXT)""" % table_name
    con = lite.connect(path_to_db)
    with con:
        cur = con.cursor()
        cur.execute(drop_state)
        cur.execute(make_table)
    load_data()
    indexdb()

def load_data():
    "Read input file into a list of tuples to pass to load_to_db."
    res = []
    for line in open(infile):
        if not line.startswith("region"):
            data = line.rstrip().split("\t")
            if len(data) != 51:
                print "An entry did not have the expected 51 fields; please"
                print "check the input and try again."
                sys.exit(1)
            res.append(tuple(data))
            if len(res) == 100000:
                load_to_db(res)
                res = []
    load_to_db(res)

def load_to_db(res):
    """Load the blastres list of tuples into a table named for file fname."""
    qs = ",".join(51 * ["?"])
    insert_val = "INSERT INTO %s VALUES(%s)" % (table_name, qs)
    con = lite.connect(path_to_db)
    with con:
        cur = con.cursor()
        cur.executemany(insert_val, res)

def indexdb():
    index_state = """CREATE INDEX Id ON %s (region, ESOffice, FY, lead_agency,
                     consult_type, consult_complex, work_category, spp_eval)
                  """ % table_name
    con = lite.connect(path_to_db)
    with con:
        cur = con.cursor()
        cur.execute(index_state)


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print(main.__doc__)
        sys.exit()
    infile = sys.argv[1]
    path_to_db = sys.argv[2]
    table_name = sys.argv[3]
    main()
