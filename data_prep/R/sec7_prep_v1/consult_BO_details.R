# consult_BO_details.R
# Make a dataframe of just the proj_IDs, BO_spp, and BO/CH_conclusions.
# Copyright (C) 2015 Defenders of Wildlife, jmalcom@defenders.org
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
# load the full dataset
###############################################################################
load("FWS_consultations_2008-2014.RData")

###############################################################################
# subset and write the df
###############################################################################
subd <- data.frame(full$activity_code,
                   full$spp_eval,
                   full$spp_BO,
                   full$BO_determination,
                   full$CH_determination
                   )

names(subd) <- c("activity_code", "spp_eval", "spp_BO", "BO_determination",
                 "CH_determination")

save(subd, file="FWS_consultations_2008-2014_BOdetail.RData")
write.table(subd,
            file="~/Dropbox/Defenders/data/ESA_consultations/FWS_consultations_2008-2014_BOdetail.tab",
            sep="\t",
            row.names=FALSE,
            quote=FALSE)

subd <- read.table("~/Dropbox/Defenders/data/ESA_consultations/FWS_BOdetail_expanded.tab",
                   header=TRUE,
                   sep="\t")
subd$combo <- paste(subd$activity_code, subd$spp_BO, sep="|")
subd$dups <- duplicated(subd$combo)
subd <- subset(subd, subd$dups==FALSE)
subd <- subd[,1:12]

save(subd, file="FWS_uniq_BO_details.Rdata")

write.table(subd,
            file="~/Dropbox/Defenders/data/ESA_consultations/FWS_uniq_BO_details.tab",
            sep="\t",
            row.names=FALSE,
            quote=FALSE)

