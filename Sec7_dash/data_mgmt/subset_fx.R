# Functions to subset an input dataset, x.
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

##############################################################################
# Return a subset of the Sec7 db (x) based on a suite of variables.
##############################################################################
sub_df <- function(x, reg, fy, esfo, agency, act_cat, cons_complex, cons_type, 
                   ne, nlaa, concur, jp, am, rpa, sp, state, formal_cons) {
    vars <- c(reg, fy, esfo, agency, act_cat, cons_complex, cons_type, ne, 
              nlaa, concur, jp, am, rpa, sp, state, formal_cons)
    if (reg != "All") {
        x <- x[x$region %in% reg, ]
    }
    if (get_min_year(x) != fy[1] | get_max_year(x) != fy[2]) {
        x <- x[fac2num(x$FY) >= fy[1] & fac2num(x$FY) <= fy[2], ]
    }
    if (esfo != "All") {
        x <- x[x$ESOffice %in% esfo, ]
    }
    if (agency != "All") {
        x <- x[x$lead_agency %in% agency, ]
    }
    if (act_cat != "All") {
        x <- x[x$work_category %in% tolower(act_cat), ]
    }
    if (cons_complex != "All") {
        x <- x[x$consult_complex %in% cons_complex, ]
    }
    if (cons_type != "All") {
        x <- x[x$consult_type %in% cons_type, ]
    }
    if (formal_cons != "All") {
        x <- x[x$formal_consult %in% formal_cons, ]
    }
    if (ne != "All") {
        if (ne == "Yes") {
            x <- x[x$n_nofx > 0 & !is.na(x$n_nofx), ]
        } else {
            x <- x[x$n_nofx == 0 & !is.na(x$n_nofx), ]
        }
    }
    if (nlaa != "All") {
        if (nlaa == "Yes") {
            x <- x[x$n_nlaa > 0 & !is.na(x$n_nlaa), ]
        } else {
            x <- x[x$n_nlaa == 0 & !is.na(x$n_nlaa), ]
        }
    }
    if (concur != "All") {
        if (concur == "Yes") {
            x <- x[x$n_conc > 0 & !is.na(x$n_conc), ]
        } else {
            x <- x[x$n_conc == 0 & !is.na(x$n_conc), ]
        }
    }
    if (jp != "All") {
        if (jp == "Yes") {
            x <- x[x$n_jeop > 0 & !is.na(x$n_jeop), ]
        } else {
            x <- x[x$n_jeop == 0 & !is.na(x$n_jeop), ]
        }
    }
    if (am != "All") {
        if (am == "Yes") {
            x <- x[x$n_admo > 0 & !is.na(x$n_admo), ]
        } else {
            x <- x[x$n_admo == 0 & !is.na(x$n_admo), ]
        }
    }
    if (rpa != "All") {
        if (rpa == "Yes") {
            x <- x[x$n_rpa > 0 & !is.na(x$n_rpa), ]
        } else {
            x <- x[x$n_rpa == 0 & !is.na(x$n_rpa), ]
        }
    }
    if (sp != "All") {
        sp_pattern <- paste(sp, collapse="|")
        sp_pattern <- gsub("(", "\\(", sp_pattern, fixed=T)
        sp_pattern <- gsub(")", "\\)", sp_pattern, fixed=T)
        indices <- grep(sp_pattern, x$spp_ev_ls, value=FALSE, fixed=FALSE)
        x <- x[indices, ]
    }

    # now for the big mess for state-level selections:
    if (state == "All") {
        return(x)
    } else {
        y <- data.frame()
        if ("AK" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "ANCHORAGE FISH AND WILDLIFE FIELD OFFICE" |
                    x$ESOffice == "FAIRBANKS FISH AND WILDLIFE FIELD OFFICE" |
                    x$ESOffice == "JUNEAU FISH AND WILDLIFE FIELD OFFICE" |
                    x$ESOffice == "KENAI FISH AND WILDLIFE FIELD OFFICE", ])
        } 
        if ("AL" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "ALABAMA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("AR" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "ARKANSAS ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("AZ" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "ARIZONA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("CA" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "ARCATA FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "CARLSBAD FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "HOPPER MOUNTAIN NATIONAL WILDLIFE REFUGE COMPLEX" |
                    x$ESOffice == "RED BLUFF FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "SACRAMENTO FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "SAN FRANCISCO BAY - DELTA FISH AND WILDLIFE" |
                    x$ESOffice == "STOCKTON FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "VENTURA FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "YREKA FISH AND WILDLIFE OFFICE", ])
        } 
        if ("CO" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "COLORADO ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "WESTERN COLORADO ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("FL" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "NORTH FLORIDA ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "PANAMA CITY ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "SOUTH FLORIDA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("GA" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "GEORGIA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("HI" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "PACIFIC ISLANDS FISH AND WILDLIFE OFFICE", ])
        } 
        if ("IA" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "ROCK ISLAND ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("ID" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "IDAHO FISH AND WILDLIFE OFFICE", ])
        } 
        if ("IL" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "CHICAGO ECOLOGICAL SERVICE FIELD OFFICE" |
                    x$ESOffice == "MARION ECOLOGICAL SERVICES SUB-OFFICE" |
                    x$ESOffice == "ROCK ISLAND ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("IN" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "BLOOMINGTON ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("KS" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "KANSAS ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("KY" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "KENTUCKY ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("LA" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "LOUISIANA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("MA" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "NEW ENGLAND ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("MD" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "CHESAPEAKE BAY ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("ME" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "MAINE ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("MI" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "EAST LANSING ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("MS" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "MISSISSIPPI ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("MN" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "TWIN CITIES ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("MO" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "COLUMBIA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("MT" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "MONTANA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("NC" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "ASHEVILLE ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "RALEIGH ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("ND" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "NORTH DAKOTA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("NE" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "NEBRASKA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("NJ" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "NEW JERSEY ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("NM" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "NEW MEXICO ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("NV" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "NEVADA FISH AND WILDLIFE OFFICE", ])
        } 
        if ("NY" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "LONG ISLAND ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "NEW YORK ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("OH" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "COLUMBUS ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("OK" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "OKLAHOMA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("OR" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "KLAMATH FALLS FISH AND WILDLIFE OFFICE" |
                        x$ESOffice == "OREGON FISH AND WILDLIFE OFFICE", ])
        } 
        if ("PA" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "PENNSYLVANIA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("SC" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "SOUTH CAROLINA ECOLOGICAL SERVICES", ])
        } 
        if ("SD" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "SOUTH DAKOTA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("TN" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "TENNESSEE ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("TX" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "ARLINGTON ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "AUSTIN ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "CORPUS CHRISTI ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "HOUSTON ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("UT" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "UTAH ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("VA" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "SOUTHWESTERN VIRGINIA ECOLOGICAL SERVICES FIELD OFFICE" |
                    x$ESOffice == "VIRGINIA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("WA" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "CENTRAL WASHINGTON FIELD OFFICE" |
                    x$ESOffice == "MID-COLUMBIA RIVER FISHERIES RESOURCE OFFICE" |
                    x$ESOffice == "SPRING CREEK NATIONAL FISH HATCHERY" |
                    x$ESOffice == "UPPER COLUMBIA RIVER FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "WASHINGTON FISH AND WILDLIFE OFFICE" |
                    x$ESOffice == "WESTERN WASHINGTON FISHERIES RESOURCE OFFICE", ])
        } 
        if ("WI" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "GREEN BAY ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("WV" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "WEST VIRGINIA ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("WY" %in% state) {
            y <- rbind(y,
                   x[ x$ESOffice == "WYOMING ECOLOGICAL SERVICES FIELD OFFICE", ])
        } 
        if ("CT" %in% state | "DE" %in% state | "NH" %in% state | 
            "RI" %in% state | "VT" %in% state) {
            y <- rbind(y,
                    x[ x$ESOffice == "no office", ] )
        }
        return(y)
    }

}

