# Sec7_formal_data_prep.R
# Summary stats and figures for Sec7 formal consultations.
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

###############################################################################
# Load packages
###############################################################################
require("lubridate")

###############################################################################
# Load the data and do initial management, then write RData file
###############################################################################
# Initial loading from tab'd file, then convert to RData for space and future
# loading.
dat <- read.table("formal_nocomma.tab",
                  stringsAsFactors=FALSE,
                  fill=TRUE,
                  header=TRUE,
                  sep="\t")

save(dat, file="formal_nocomma.RData")
rm(dat)

# After initial read, just load the RData (faster, smaller size)
load("formal_nocomma.RData")
names(dat)

# Convert to useful types...
to_factor <- c(1:10, 14:17, 19, 21, 24:35, 38)
for(i in to_factor) {
    dat[,i] <- as.factor(dat[,i])
}

to_date <- c(11:13, 20)
for(i in to_date) {
    dat[,i] <- as.Date(dat[,i])
}

parts <- strsplit(x=dat[,37], split=" - ")
Action.Category <- sapply(parts, "[", 1)
dat <- data.frame(dat[,1:37], Action.Category, dat[,38:length(dat)])

# Re-save the data 
save(dat, file="formal_intermed.RData")

###############################################################################
# Load the cleaned data and do more checks
###############################################################################
# After initial read, just load the RData (faster, smaller size)
load("formal_intermed.RData")

names(dat)
levels(dat[,1])
levels(dat[,2])
levels(dat[,3])
length(levels(dat[,4])) # number of actions by ID
length(levels(dat[,5])) # number of actions by action name (some repeats)
levels(dat[,6])         # only one level, not useful
levels(dat[,7])
summary(dat[,7])        # summary of Active vs. Concluded
levels(dat[,8])
summary(dat[,8])        # summary of ARRA funding source
levels(dat[,9])
levels(dat[,10])
dat[,10] <- as.factor(sub('|', ',', x=dat[,10], fixed=TRUE))
levels(dat[,10])

#-----------------------
# Extract the species list from dat for analysis in Python
#
# The species list appears too long--over 1700 spp--so need to check if there
# are typos that are increasing the list length. The python
levels(dat[,14])
species <- levels(dat[,14])
write.table(x=species, 
            file="formal_spp_list.txt", 
            sep="\t",
            quote=FALSE,
            row.names=FALSE)
#-----------------------

levels(dat[,15])
dat[,15] <- as.factor(sub('|', ',', x=dat[,15], fixed=TRUE))
levels(dat[,15])
levels(dat[,16])
dat[,16] <- as.factor(sub('|', ',', x=dat[,16], fixed=TRUE))
levels(dat[,16])
levels(dat[,17])

#-----------------------
dat[,19] <- as.factor(dat[,19])
summary(dat[,19])

# #-----------------------
# # Remove data points with bad dates, including
# #   conclusion dates that disagree with reality
# #   records where the conclusion date is < start date
# #   
# levels(as.factor(dat[,18]))
# bad_conc_date <- subset(dat, dat[,18] > 2014)
# summary(bad_conc_date)
# dat2 <- subset(dat, dat[,18] <= 2014)
# dim(dat2)

# summary(dat[,20])
# levels(as.factor(year(dat[,20])))
# bad_active_conc <- subset(dat, year(dat[,20]) < 1990 | year(dat[,20]) > 2014)
# dat2 <- subset(dat2, year(dat2[,20]) >= 1990 | year(dat2[,20]) <= 2014)
# dim(dat2)

bad_start_end <- subset(dat, dat[,11] > dat[,13])
dim(bad_start_end)
summary(bad_start_end)
droplevels(bad_start_end$Activity.Code)
summary(bad_start_end$Activity.Code)
length(levels(droplevels(bad_start_end$Activity.Code)))

dat2 <- subset(dat, dat[,11] <= dat[,13])
dim(dat2)

#----------------------
# Rename these vars:
newnames <- c("region", "ESOffice", "FY", "activity_code",
              "title", "activity_type",
              "status", "ARRA", "lead_agency", "staff_lead", 
              "start_date", "due_date", "FWS_concl_date", "spp_eval", 
              "staff_support", "support_agency", "FY_start", "FY_concl", 
              "active_concl", "date_active_concl", "timely_concl", 

              "n_days_elapsed", "n_days_due", "hours_logged", 
              "events_logged", "no_FWS_performed", "formal_consult", 
              "consult_type", "consult_complex", "date_formal_consult", 
              "withdrawn", "spp_BO", "BO_determination", 
              "CH_determination", "CH_flag", "take", "work_type",

              "work_category", "performance", "datum", "lat_dec_deg",
              "long_dec_deg", "lat_deg", "lat_min", "lat_sec",
              "long_deg", "long_min", "long_sec", "UTM_E",
              "UTM_N", "UTM_zone")

names(dat2) <- newnames


#-----------------------
# Write the trimmed data to tab'd file for 
write.table(dat2,
            file="formal_2008-2014_cleaned.tab",
            sep="\t",
            row.names=FALSE,
            quote=FALSE)
save(dat2, file="formal_2008-2014_cleaned.RData")

###############################################################################
# Collapse the cleaned data from above to one project ID per case
#
# Use a call to `system` to run the Python collapse script
###############################################################################
script <- "~/Defenders_JWM/Python/Sec7/collapse_to_projectID.py"
infile <- "formal_2008-2014_cleaned.tab"
outfil <- "formal_compressed.tab"
command <- paste("python", script, infile, ">", outfil)
system(command)

###############################################################################
# Clear and then reload data
###############################################################################
rm(list=ls())
dat <- read.table("formal_compressed.tab",
                  sep="\t",
                  header=TRUE,
                  stringsAsFactors=FALSE)

to_factor <- c(1:10, 15:17, 19, 21, 24:31, 38)
for(i in to_factor) {
    dat[,i] <- as.factor(dat[,i])
}

to_date <- c(11:13, 20)
for(i in to_date) {
    dat[,i] <- as.Date(dat[,i])
}

#----------------------
# Rename these vars:
newnames <- c("region", "ESOffice", "FY", "activity_code",
              "title", "activity_type",
              "status", "ARRA", "lead_agency", "staff_lead", 
              "start_date", "due_date", "FWS_concl_date", "spp_eval", 
              "staff_support", "support_agency", "FY_start", "FY_concl", 
              "active_concl", "date_active_concl", "timely_concl", 

              "n_days_elapsed", "n_days_due", "hours_logged", 
              "events_logged", "no_FWS_performed", "formal_consult", 
              "consult_type", "consult_complex", "date_formal_consult", 
              "withdrawn", "spp_BO", "BO_determination", 
              "CH_determination", "CH_flag", "take", "work_type",

              "work_category", "performance", "datum", "lat_dec_deg",
              "long_dec_deg", "lat_deg", "lat_min", "lat_sec",
              "long_deg", "long_min", "long_sec", "UTM_E",
              "UTM_N", "UTM_zone")

names(dat) <- newnames

# Get the splits of species
ls_spp_eval <- strsplit(x=dat$spp_eval, split="[|]")
n_spp_eval <- lapply(ls_spp_eval, FUN=length)
dat$n_spp_eval <- unlist(n_spp_eval)

ls_spp_BO <- strsplit(x=dat$spp_BO, split="[|]")
n_spp_BO <- lapply(ls_spp_BO, FUN=length)
dat$n_spp_BO <- unlist(n_spp_BO)

dat$delta_spp_eval_BO <- dat$n_spp_BO - dat$n_spp_eval 
dim(dat)

# Re-save the data 
save(dat, file="formal_compressed.RData")
rm(list=ls())


