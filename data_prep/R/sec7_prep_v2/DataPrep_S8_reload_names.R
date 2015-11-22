# DataPrep_S8_reload_names.R
# Simple script to parse the species evaluated list after name cleanup.
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

base <- "~/Repos/defenders_sec7_shiny/data/"
infile <- paste(base, "sec7_updated_names_30Jul2015.tab", sep="")
to_save <- paste(base, "FWS_S7_clean_30Jul2015.RData", sep="")
full <- read.table(infile,
                   sep="\t",
                   header=TRUE,
                   stringsAsFactors=FALSE)

dim(full)
names(full)

spp_list <- strsplit(full$spp_ev_ls, split="; ")
full$spp_ev_ls <- spp_list
full$work_category <- as.factor(full$work_category)


save(full, file=to_save)

