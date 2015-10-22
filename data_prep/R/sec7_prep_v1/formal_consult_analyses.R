# informal_consult_analyses.R
# Just what the name says.
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
# Imports
###############################################################################
require("lubridate")

###############################################################################
# Functions
###############################################################################


###############################################################################
# Load the data
###############################################################################
# Re-save the data 
load("formal_compressed.RData")
dim(dat)
names(dat)

###############################################################################
# Start the actual analyses 
###############################################################################
# summary tables
n_consult_region <- table(dat$region)
n_consult_ESFO <- table(dat$ESOffice)
n_consult_year <- table(dat$FY)
n_timely_concl <- table(dat$timely_concl)
n_consult_region
n_consult_ESFO
n_consult_year
n_timely_concl

#---------------------
# Which regions, offices are on-time, any overall trend in time?
#---------------------
time_by_region <- table(dat$timely_concl, dat$region)
pct_late_region <- time_by_region[1,] / (time_by_region[1,] + time_by_region[3,])
pct_late_region

time_by_year <- table(dat$timely_concl, dat$FY)
pct_time_by_year <- time_by_year[1,] / (time_by_year[1,] + time_by_year[3,])
pct_time_by_year

time_by_region_year <- table(dat$region, dat$FY, dat$timely_concl)
time_by_region_year
pct_late_region_year <- time_by_region_year[,,1] / (time_by_region_year[,,1] + 
                                                   time_by_region_year[,,3])
pct_late_region_year

time_by_office <- table(dat$timely_concl, dat$ESOffice)
pct_late_office <- time_by_office[1,] / (time_by_office[1,] + time_by_office[3,])
sort(pct_late_office)

#-------------
# some plots
tmp <- cbind(pct_time_by_year, n_consult_year)
plot(tmp[,1] ~ tmp[,2],
     pch=16,
     cex=1.7,
     xlab="No. consultations per year",
     ylab="% formal consultations not timely",
     main="")
abline(lm(tmp[,1] ~ tmp[,2]), col="red")





