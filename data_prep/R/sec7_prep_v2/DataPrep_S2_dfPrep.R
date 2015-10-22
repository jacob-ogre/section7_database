# Prepare a tab'd file of Section 7 data for analysis.
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

# require(lubridate)

###############################################################################
# Load the data, rename the variables, then write RData file
###############################################################################
# Initial loading from tab'd file, then convert to RData for space and future
# loading.
# infile <- "~/Dropbox/Defenders/data/ESA_consultations/TABs/FWS_consultations_08-14.tab"
infile <- "~/OneDrive/Defenders/data/ESA_consultations/TABs/2014-Apr2015_consults.tab"
dat <- read.table(infile,
                  stringsAsFactors=FALSE,
                  sep="\t",
                  # fill=TRUE,
                  header=TRUE)
dim(dat)

newnames <- c("region", "ESOffice", "FY", "activity_code", "title", 
              "activity_type", "status", "ARRA", "lead_agency", "staff_lead", 
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

###############################################################################
# Fix a bunch of errors
###############################################################################
dat <- subset(dat, dat$region != "Lead Region")

dat$active_concl <- as.factor(gsub("concluded,", 
                                   "concluded", 
                                   dat$active_concl, 
                                   fixed=TRUE))

dat$active_concl <- as.factor(gsub("active,", 
                                   "active", 
                                   dat$active_concl, 
                                   fixed=TRUE))

dat$date_active_concl <- gsub("1008-10-15",
                              "2008-10-15",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("1008-10-15",
                              "2008-10-15",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$date_active_concl <- gsub("1008-10-18",
                              "2008-10-18",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("1008-10-18",
                              "2008-10-18",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FY_concl <- gsub("1008",
                     "2008",
                     dat$FY_concl,
                     fixed=TRUE)

dat$FY_concl <- gsub("1009",
                     "2009",
                     dat$FY_concl,
                     fixed=TRUE)

dat$date_active_concl <- gsub("2104-05-01",
                              "2014-05-01",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("2104-05-01",
                           "2014-05-01",
                           dat$date_active_concl,
                           fixed=TRUE)

dat$FY_concl <- gsub("2104",
                     "2014",
                     dat$FY_concl,
                     fixed=TRUE)

dat$date_active_concl <- gsub("2103-05-14",
                              "2013-05-14",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("2103-05-14",
                              "2013-05-14",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FY_concl <- gsub("2103",
                     "2013",
                     dat$FY_concl,
                     fixed=TRUE)

dat$date_active_concl <- gsub("2100-04-04",
                              "2011-04-04",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("2100-04-04",
                              "2011-04-04",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$date_active_concl <- gsub("2019-07-19",
                              "2013-07-19",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("2019-07-19",
                           "2013-07-19",
                           dat$FWS_concl_date,
                           fixed=TRUE)

dat$FY_concl <- gsub("2019",
                     "2013",
                     dat$FY_concl,
                     fixed=TRUE)

dat$date_active_concl <- gsub("2016-02-28",
                              "2013-07-19",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("2016-02-28",
                              "2013-07-19",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$date_active_concl <- gsub("transport",
                              "transportation",
                              dat$date_active_concl,
                              fixed=TRUE)

dat$date_active_concl <- gsub("1990-01-01",
                              NA,
                              dat$date_active_concl,
                              fixed=TRUE)

dat$FWS_concl_date <- gsub("1990-01-01",
                              NA,
                              dat$date_active_concl,
                              fixed=TRUE)

# drop two consultations with unfixable dates:
dat <- subset(dat, dat$date_active_concl != "2016-02-28")
dat <- subset(dat, dat$date_active_concl != "2017-04-07")

###############################################################################
# Do some type conversions
###############################################################################
to_factor <- c(1:10, 14:19, 21, 24:29, 31:32, 35, 37:39)
for(i in to_factor) {
    dat[,i] <- as.factor(dat[,i])
}

to_date <- c(11:13, 20, 30)
for(i in to_date) {
    dat[,i] <- as.Date(dat[,i])
}

###############################################################################
# Let's check some variables...
###############################################################################
# levels(dat[,1])
# levels(dat[,2])
# levels(dat[,3])
# length(levels(dat[,4])) # number of actions by ID
# length(levels(dat[,5])) # number of actions by action name (some repeats)
# levels(dat[,6])         # only one level, not useful
# levels(dat[,7])
# summary(dat[,7])        # summary of Active vs. Concluded
# levels(dat[,8])
# summary(dat[,8])        # summary of ARRA funding source
# levels(dat[,9])
# levels(dat[,10])
# levels(dat[,14])
# levels(dat[,15])
# levels(dat[,16])
# levels(dat[,17])
# levels(dat[,19])
# summary(dat[,20])
# levels(dat[,21])
# levels(dat[,24])
# levels(dat[,25])
# levels(dat[,26])
# levels(dat[,27])
# levels(dat[,28])
# levels(dat[,29])
# summary(dat[,30])
# levels(dat[,31])
# levels(dat[,32])
# summary(dat[,33])
# levels(dat[,37])
# levels(dat[,38])
# levels(dat[,39])

elapsed <- as.numeric(dat$FWS_concl_date - dat$start_date)
# hist(elapsed)
dat <- data.frame(dat, elapsed)

neg_time <- subset(dat, dat$elapsed < 0)
# dim(neg_time)
# length(levels(droplevels(neg_time$activity_code)))

# drop consultations with unfixable dates:
dat <- subset(dat, dat$elapsed >= 0)

to_factor <- c(1:10, 14:19, 21, 24:29, 31:32, 35, 37:39)
for(i in to_factor) {
    dat[,i] <- droplevels(dat[,i])
}

###############################################################################
# Compress the dataframe to unique ID:spp_BO combinations
###############################################################################
dat$combo <- paste(dat$activity_code, dat$spp_eval, dat$spp_BO, sep="|")
dat$dups <- duplicated(dat$combo)
d2 <- subset(dat, dat$dups == FALSE)

save(dat, 
     file="~/Dropbox/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-14_filtered.RData")

###############################################################################
# Reduce the df to the variables that are actually useful
###############################################################################
names(dat)
d2 <- d2[, -54]
d2 <- d2[, -53]
d2 <- d2[, -36]
d2 <- d2[, -31]
d2 <- d2[, -26]
d2 <- d2[, -22]
d2 <- d2[, -19]
d2 <- d2[, -16]
d2 <- d2[, -7]
d2 <- d2[, -6]
# dim(d2)
# names(d2)

filtout <- "~/Dropbox/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-14_filt_uniq.RData"
save(d2, file=filtout)

filtout2 <- "~/Dropbox/Defenders/data/ESA_consultations/TABs/FWS_consults_08-14_filt_uniq.tab"
write.table(d2,
            file=filtout2,
            quote=FALSE,
            row.names=FALSE,
            sep="\t")




