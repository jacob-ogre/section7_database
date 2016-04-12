# Code to clean the (probably ugly) new consultation data.
# Copyright (c) 2016 Defenders of Wildlife, jmalcom@defenders.org

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
# 

library(dplyr)
library(readr)

##########################################################################
# Load the data
##########################################################################

base <- "/Users/jacobmalcom/Dropbox/TAILS data/"
file = paste0(base, "/extracted/new_data_raw.tsv")

data <- read_tsv(file)
head(data)
dim(data)

base2 <- "/Users/jacobmalcom/Repos/Defenders/section7_database/defenders_sec7_shiny/data/"
load(paste0(base2, "FWS_S7_clean_30Jul2015.RData"))
orig <- full
rm(full)
dim(orig)

##########################################################################
# Let's get some summaries
##########################################################################
get_summaries <- function(x) {
    for (i in 1:length(x)) {
        cur_var <- x[[i]]
        cat(paste0("Variable: ", names(x)[i], "\n"))
        if (is.factor(cur_var)) {
            n_levels <- length(levels(cur_var))
            cat(paste0("\t\tFactor with ", n_levels, " levels\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(levels(cur_var)), "\n"))
        } else if (is.numeric(cur_var)) {
            cat(paste0("\tNumeric\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(levels(cur_var)), "\n"))
            cat(paste0("\tMean:", mean(cur_var), "\n"))
        } else if (is.character(cur_var)) {
            cat(paste0("\tCharacter\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(cur_var), "\n"))
        } else {
            cat(paste0("\t????\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(cur_var), "\n"))
        }
        cat("\n=======================\n\n")
    }
}
get_summaries(data)

##############################################################################
# Fix up the variable names...
##############################################################################
orig_name <- names(orig)
data_name <- names(data)

head(data_name, 30)
tail(data_name, 25)
head(orig_name, 20)

data_names <- c("region", "ESOffice", "FY", "activity_code",
                "title", "activity_type", "status", "ARRA",
                "lead_agency", "staff_lead", "start_date", "due_date",
                "FWS_concl_date", "spp_ev", "staff_support", "support_agency",
                "datum", "lat_dec_deg", "long_dec_deg", "lat_deg", 
                "lat_min", "lat_sec", "long_deg", "long_min", 
                "long_sec", "UTM_E", "UTM_N", "UTM_zone", 
                "FY_start", "FY_concl", "active", "timely_concl",
                "elapsed", "due_days", "hours_logged", "events_logged",
                "FWS_no_work", "formal_consult", "consult_type", "consult_complex",
                "date_formal_consult", "withdrawn", "spp_BO", "BO_determin",
                "CH_determin", "CH_flag", "take", "work_type", "perf_category")
length(data_names)
names(data) <- data_names

names(orig)
names(data)

##############################################################################
# Make new variables for the df
##############################################################################

# First the place data collapse
base3 <- "/Users/jacobmalcom/Repos/Defenders/section7_database/data_prep/R/sec7_prep_v3/"
st_ESO <- read_tsv(paste0(base3, "state_ESO_mappings.tsv"))

ESOffice <- tapply(data$ESOffice,
                   INDEX = data$activity_code,
                   FUN = unique)
region <- tapply(data$region,
                 INDEX = data$activity_code,
                 FUN = unique)

ESO_df <- data.frame(activity_code = names(ESOffice),
                     ESOffice = as.vector(ESOffice))
reg_df <- data.frame(activity_code = names(region),
                     region = as.vector(region))

state <- merge(ESO_df, st_ESO, by="ESOffice")
place <- merge(state, reg_df, by="activity_code")
head(place)
place <- place[, c(1, 4, 3, 2)]

by_activity <- function(x) {
    res <- tapply(x,
                  INDEX = data$activity_code,
                  FUN = unique)
    if (length(res) != 11220) {
        print("non-uniques")
    }
    return(res)
}

title <- by_activity(data$title)
lead_agency <- by_activity(data$lead_agency)
FY <- by_activity(data$FY)
FY_start <- by_activity(data$FY_start)
FY_concl <- by_activity(data$FY_concl)
start_date <- by_activity(data$start_date)
date_formal_consult <- by_activity(data$date_formal_consult)
due_date <- by_activity(data$due_date)
FWS_concl_date <- by_activity(data$FWS_concl_date)
elapsed <- by_activity(data$elapsed)
timely_concl <- by_activity(data$timely_concl)
hours_logged <- by_activity(data$hours_logged)
events_logged <- by_activity(data$events_logged)
formal_consult <- by_activity(data$formal_consult)
consult_type <- by_activity(data$consult_type)
consult_complex <- by_activity(data$consult_complex)
work_type <- by_activity(data$work_type) # need to make work_category!
ARRA <- by_activity(data$ARRA)
datum <- by_activity(data$datum)
lat_dec_deg <- by_activity(data$lat_dec_deg)
long_dec_deg <- by_activity(data$long_dec_deg)
lat_deg <- by_activity(data$lat_deg)
lat_min <- by_activity(data$lat_min)
lat_sec <- by_activity(data$lat_sec)
long_deg <- by_activity(data$long_deg)
long_min <- by_activity(data$long_min)
long_sec <- by_activity(data$long_sec)
UTM_E <- by_activity(data$UTM_E)
UTM_N <- by_activity(data$UTM_N)
UTM_zone <- by_activity(data$UTM_zone)


######################
# species lists
make_spp_ls <- function(x, y) {
    res <- tapply(x,
                  INDEX = y,
                  FUN = function(z) { list(unique(z)) })
    return(res)
}

spp_ev_ls <- make_spp_ls(data$spp_ev, data$activity_code)
spp_BO_ls <- make_spp_ls(data$spp_BO, data$activity_code)
n_spp_ev <- lapply(FUN=length, X=spp_ev_ls)





