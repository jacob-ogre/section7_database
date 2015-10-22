# combine_formal_informal.R
# Simply combine the formal and informal cleaned RData.
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
# Read the data
###############################################################################
# First, the compressed-form datasets:
load("formal_compressed.RData")
formal <- dat
rm(dat)
load("informal_compressed.RData")
informal <- dat
rm(dat)

full <- rbind(formal, informal)

save(full, file="FWS_consultations_2008-2014_byProj.RData")
write.table(full,
            file="FWS_consultations_2008-2014_byProj.tab",
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

rm(list=ls())

#----------------
# Next, the full-form datasets:
load("formal_2008-2014_cleaned.RData")
formal <- dat2
rm(dat)
load("informal_2008-2014_cleaned.RData")
informal <- dat2
rm(dat2)
ls()

names(formal) == names(informal)
names(formal)
names(informal)
dim(formal)
dim(informal)

full <- rbind(formal, informal)

#----------------------
# One more filter--for bad dates!
#----------------------
full <- subset(full, full$date_active_concl - full$start_date >= 0)

save(full, file="FWS_consultations_2008-2014.RData")
write.table(full,
            file="FWS_consultations_2008-2014.tab",
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

# load(file="FWS_consultations_2008-2014.RData")
