# regional_analyses.R
# Basic script to quickly get some stats on a region, ESFO level.
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


#############################################################################
# Load and subset data
#############################################################################
load("~/Dropbox/Defenders_data/FWS_consult_08-14_semifinal.RData")

REGION <- "3"
ESFO <- "EAST LANSING ECOLOGICAL SERVICES FIELD OFFICE"

r3 <- subset(dat, dat$region==REGION)
MI <- subset(dat, dat$ESOffice==ESFO)
dim(dat)
dim(r3)
dim(MI)

#############################################################################
# Summary stats
#############################################################################
US_formal <- subset(dat, dat$formal_consult=="Yes")
r3_formal <- subset(r3, r3$formal_consult=="Yes")
MI_formal <- subset(MI, MI$formal_consult=="Yes")
length(US_formal$formal_consult)
length(r3_formal$formal_consult)
length(MI_formal$formal_consult)

US_jeop <- subset(dat, dat$Jeopardy==1)
r3_jeop <- subset(r3, r3$Jeopardy==1)
MI_jeop <- subset(MI, MI$Jeopardy==1)
dim(US_jeop)
dim(r3_jeop)
dim(MI_jeop)

US_admod <- subset(dat, dat$AdvMod==1)
r3_admod <- subset(r3, r3$AdvMod==1)
MI_admod <- subset(MI, MI$AdvMod==1)
dim(US_admod)
dim(r3_admod)
dim(MI_admod)

US_rpa <- subset(dat, dat$RPA==1)
r3_rpa <- subset(r3, r3$RPA==1)
MI_rpa <- subset(MI, MI$RPA==1)
dim(US_rpa)
dim(r3_rpa)
dim(MI_rpa)

###############
# Time
###############
US_time_med <- median(dat$elapsed, na.rm=TRUE)
r3_time_med <- median(r3$elapsed, na.rm=TRUE)
MI_time_med <- median(MI$elapsed, na.rm=TRUE)
US_time_med
r3_time_med
MI_time_med

US_time_med_formal <- median(US_formal$elapsed, na.rm=TRUE)
r3_time_med_formal <- median(r3_formal$elapsed, na.rm=TRUE)
MI_time_med_formal <- median(MI_formal$elapsed, na.rm=TRUE)
US_time_med_formal
r3_time_med_formal
MI_time_med_formal

US_time_max <- max(dat$elapsed, na.rm=TRUE)
r3_time_max <- max(r3$elapsed, na.rm=TRUE)
MI_time_max <- max(MI$elapsed, na.rm=TRUE)
US_time_max
r3_time_max
MI_time_max

###############
# Personnel
###############
US_personnel <- length(levels(droplevels(dat$staff_lead)))
r3_personnel <- length(levels(droplevels(r3$staff_lead)))
MI_personnel <- length(levels(droplevels(MI$staff_lead)))
US_personnel
r3_personnel
MI_personnel

###############
# by FY
###############
table(dat$FY)
table(r3$FY)
table(MI$FY)

###############
# species
###############
US_n_spp <- mean(dat$n_spp_eval)
r3_n_spp <- mean(r3$n_spp_eval)
MI_n_spp <- mean(MI$n_spp_eval)
US_n_spp
r3_n_spp
MI_n_spp

###############
# Top agencies
###############
tail(sort(table(dat$lead_agency)))
tail(sort(table(r3$lead_agency)))
tail(sort(table(MI$lead_agency)))

