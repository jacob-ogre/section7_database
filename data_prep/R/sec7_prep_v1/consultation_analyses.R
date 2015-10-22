# consultation_analyses.R
# Analysis of the combined formal, informal consultation fulla.
# Copyright (C) 2014 Jacob Malcom, jacob.w.malcom@gmail.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Founfullion; either version 2 of the License, or
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
# Load the fulla
###############################################################################
# Re-save the fulla 
load("FWS_consultations_2008-2014_byProj.RData")
dim(full)
names(full)

full$ESOffice <- as.factor(gsub("|", ",", 
                           as.character(full$ESOffice), 
                           fixed=TRUE))


###############################################################################
# Start the actual analyses 
###############################################################################
# summary tables
n_consult_region <- table(full$region)
n_consult_ESFO <- table(full$ESOffice)
n_consult_year <- table(full$FY)
n_timely_concl <- table(full$timely_concl)
n_consult_region
n_consult_ESFO
n_consult_year
n_timely_concl

#---------------------
# Which regions, offices are on-time, any overall trend in time?
#---------------------
time_by_region <- table(full$timely_concl, full$region)
pct_late_region <- time_by_region[1,] / (time_by_region[1,] + time_by_region[3,])
pct_late_region

time_by_year <- table(full$timely_concl, full$FY)
pct_time_by_year <- time_by_year[1,] / (time_by_year[1,] + time_by_year[3,])
pct_time_by_year

time_by_region_year <- table(full$region, full$FY, full$timely_concl)
time_by_region_year
pct_late_region_year <- time_by_region_year[,,1] / (time_by_region_year[,,1] + 
                                                   time_by_region_year[,,3])
pct_late_region_year

time_by_office <- table(full$timely_concl, full$ESOffice)
pct_late_office <- time_by_office[1,] / (time_by_office[1,] + time_by_office[3,])
sort(pct_late_office)

number_per_year <- table(full$FY)
number_per_year

number_per_region_year <- table(full$region, full$FY)
number_per_region_year

# TODO: CHECK THAT THIS IS WHAT I ACTUALLY WANT...
formal_by_yr_by_timely <- table(full$FY, full$formal_consult, full$timely_concl)
pct_formal_time_yr <- formal_by_yr_by_timely[,,1] / (formal_by_yr_by_timely[,,1] +
                                                    formal_by_yr_by_timely[,,3])
pct_formal_time_yr

#-----------------
# high-level test of factors affecting pct consult late
#-----------------
n_reg_yr <- as.data.frame(number_per_region_year)
names(n_reg_yr) <- c("region", "FY", "Freq")
head(n_reg_yr, 10)

class(pct_late_region_year) <- "table"
pct_late_reg_yr <- as.data.frame(pct_late_region_year)
names(pct_late_reg_yr) <- c("region", "FY", "pct_late")
head(pct_late_reg_yr, 10)

amod <- lm(pct_late_reg_yr$pct_late ~ n_reg_yr$Freq * n_reg_yr$region)
summary(amod)

bmod <- lm(pct_late_reg_yr$pct_late ~ n_reg_yr$Freq + n_reg_yr$region)
summary(bmod)

cmod <- lm(pct_late_reg_yr$pct_late ~ n_reg_yr$Freq)
summary(cmod)

dmod <- lm(pct_late_reg_yr$pct_late ~ n_reg_yr$region)
summary(dmod)

plot(pct_late_reg_yr$pct_late ~ n_reg_yr$Freq)

sub_pct_late <- subset(pct_late_reg_yr, pct_late_reg_yr$region != 9)
sub_num_cons <- subset(n_reg_yr, n_reg_yr$region != 9)

emod <- lm(sub_pct_late$pct_late ~ sub_num_cons$Freq + sub_num_cons$region)
summary(emod)

plot(sub_pct_late$pct_late ~ sub_num_cons$Freq)
abline(lm(sub_pct_late$pct_late ~ sub_num_cons$Freq), col="red")

fmod <- lm(sub_pct_late$pct_late ~ sub_num_cons$region)
summary(fmod)
fmod_resid <- resid(fmod)

plot(fmod_resid ~ sub_num_cons$Freq)
abline(lm(fmod_resid ~ sub_num_cons$Freq), col="red")

#----------------------
# pct consult late as fx of N formal consultations
#----------------------
formal <- subset(full, full$formal_consult=="Yes")
dim(formal)

formal_reg_year <- table(formal$region, formal$FY, formal$timely_concl)
formal_reg_year
formal_late_reg_yr <- formal_reg_year[,,1] / (formal_reg_year[,,1] + 
                                                   formal_reg_year[,,3])
formal_late_reg_yr

formal_N_reg_yr <- table(formal$region, formal$FY)
formal_N_reg_yr

class(formal_N_reg_yr) <- "table"
formal_N_reg_yr_df <- as.data.frame(formal_N_reg_yr)
names(formal_N_reg_yr_df) <- c("region", "FY", "Freq")
head(formal_N_reg_yr_df, 10)

class(formal_late_reg_yr) <- "table"
formal_pct_late_reg_yr_df <- as.data.frame(formal_late_reg_yr)
names(formal_pct_late_reg_yr_df) <- c("region", "FY", "pct_late")
head(formal_pct_late_reg_yr_df, 10)

# Drop R9 b/c it's just an outlier...
sub_formal_N_reg_yr_df <- subset(formal_N_reg_yr_df, formal_N_reg_yr_df$region!=9)
sub_formal_pct_late_reg_yr_df <- subset(formal_pct_late_reg_yr_df,
                                        formal_pct_late_reg_yr_df$region!=9)

gmod <- lm(sub_formal_pct_late_reg_yr_df$pct_late ~ 
           sub_formal_N_reg_yr_df$Freq + sub_formal_N_reg_yr_df$region)
summary(gmod)
hist(resid(gmod))

hmod <- lm(sub_formal_pct_late_reg_yr_df$pct_late ~ sub_formal_N_reg_yr_df$region)
summary(hmod)
resid_sub_formal_late <- resid(hmod)
hist(resid_sub_formal_late)

plot(resid_sub_formal_late ~ sub_formal_N_reg_yr_df$Freq)
abline(lm(resid_sub_formal_late ~ sub_formal_N_reg_yr_df$Freq), col="red")
hist(sub_formal_N_reg_yr_df$Freq)

###############################################################################
# Other plots
###############################################################################
tmp <- cbind(pct_time_by_year, n_consult_year)
plot(tmp[,1] ~ tmp[,2],
     pch=16,
     cex=1.7,
     ylim=c(0,1),
     xlab="No. consultations per year",
     ylab="% formal consultations not timely",
     main="")
abline(lm(tmp[,1] ~ tmp[,2]), col="red")











































###############################################################################
# Counts of consultations with the Mills College project spp
###############################################################################
length(grep(pattern="Bull Trout", x=full$spp_eval))
length(grep(pattern="Mountain yellow", x=full$spp_eval))
length(grep(pattern="gnatcatcher", x=full$spp_eval))
length(grep(pattern="cheeked", x=full$spp_eval))
length(grep(pattern="puzzle", x=full$spp_eval))
length(grep(pattern="Gopher tortoise", x=full$spp_eval))
length(grep(pattern="Relict trillium", x=full$spp_eval))
length(grep(pattern="Littlewing", x=full$spp_eval))
length(grep(pattern="Bog (=Muhlenberg) turtle", x=full$spp_eval))
length(grep(pattern="Eastern prairie", x=full$spp_eval))
length(grep(pattern="Lesser prairie-chicken", x=full$spp_eval))
length(grep(pattern="Alabama beach mouse", x=full$spp_eval))
length(grep(pattern="Perdido Key beach mouse", x=full$spp_eval))

