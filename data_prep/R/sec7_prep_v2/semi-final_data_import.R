# Semi-final re-import and saving of data file (post-salmonid fix).
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

full <- read.table("data/sec7_salmonids_fixed.tab",
                   sep="\t",
                   header=TRUE,
                   stringsAsFactors=FALSE)

dim(full)
names(full)

full[full$activity_code == "05E2PA00-2013-I-0212", ]$lead_agency <- "-- OTHER: CONSULTANT --"
full[full$activity_code == "05E2VA00-2014-F-0209", ]$lead_agency <- "-- OTHER: CONSULTANT --"
full[full$activity_code == "52420-2009-F-0862", ]$lead_agency <- "-- OTHER: CONSULTANT --"

full[full$activity_code == "05E2PA00-2013-I-0212", ]$lead_agency
full[full$activity_code == "05E2VA00-2014-F-0209", ]$lead_agency
full[full$activity_code == "52420-2009-F-0862", ]$lead_agency

full$date_active_concl <- ifelse(full$date_active_concl == "1990-01-01",
                                 NA,
                                 full$date_active_concl)

new <- full[,-c(49:51)]

new <- new[,c(2:3, 49, 1, 5, 7, 4, 11:12, 8, 20, 9:10, 35, 13:14, 15:19, 21:22, 6, 23:34, 36:48)]

new[new$activity_code == "01EIFW00-2012-F-0015", ]
new[new$activity_code == "01EOFW00-2013-F-0037", ]
new[new$activity_code == "01EOFW00-2013-F-0090", ]

to_factor <- c(2:4, 6:9, 16:24, 48:49)
for (i in to_factor) {
    new[[i]] <- as.factor(new[[i]])
}

spp_ls <- new$spp_ev_ls
idx <- grep(pattern="c(", x=spp_ls, fixed=TRUE)
idx2 <- grep(pattern="),", x=spp_ls, fixed=TRUE)
probs <- new[idx,]
prob2 <- new[idx2,]

#OK, first take care of special cases:
int_spp_ls <- gsub(pattern="c(", replacement="", x=spp_ls, fixed=TRUE)
int_spp_ls <- gsub(pattern="=squawfish),", replacement="=squawfish|,", x=int_spp_ls, fixed=TRUE)
int_spp_ls <- gsub(pattern="=wood),", replacement="=wood|,", x=int_spp_ls, fixed=TRUE)
int_spp_ls <- gsub(pattern="lucius));", replacement="lucius);", x=int_spp_ls, fixed=TRUE)
int_spp_ls <- gsub(pattern="chrysoparia));", replacement="chrysoparia);", x=int_spp_ls, fixed=TRUE)

# Now do the necessary big ), replacement:
lte_spp_ls <- gsub(pattern="),", replacement=");", x=int_spp_ls, fixed=TRUE)
lte_spp_ls <- gsub(pattern="|,", replacement="),", x=lte_spp_ls, fixed=TRUE)
lte_spp_ls <- gsub(pattern="lucius))", replacement="lucius)", x=lte_spp_ls, fixed=TRUE)

new_spp_ls <- strsplit(lte_spp_ls, split="; ", fixed=TRUE)

new$spp_ev_ls <- new_spp_ls

full <- new
save(full, file="data/FWS_S7_clean_15Jul2015_postSalmon.RData")

##############################################################################
# Maybe the final fixes??? Double parentheses...
new <- make_writeable(full)
new_ls <- new$spp_ev_ls
new_ls_2 <- gsub("))", ")", new_ls, fixed=TRUE)

dbl <- grep("))", new_ls, fixed=TRUE)
dbl
dbl <- grep("))", new_ls_2, fixed=TRUE)
dbl

new_ls_3 <- strsplit(new_ls_2, split="; ", fixed=TRUE)
length(new_ls_3)

full$spp_ev_ls <- new_ls_3
save(full, file="data/FWS_S7_clean_17Jul2015.RData")



