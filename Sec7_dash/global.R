# Global functions to be called at app initiation.
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

#############################################################################
# Load packages and source files
#############################################################################
# require(ggplot2)
require(httr)
require(lattice)
require(lubridate)
require(RCurl)
require(RJSONIO)
require(shiny)
library(shinydashboard)
library(shinyBS)
require(xtable)
library(DT)

library(leaflet)
library(maptools)
library(sp)

source("data_mgmt/make_dataframes.R")
source("data_mgmt/subset_fx.R")
source("data_mgmt/summary_fx.R")
source("plot/bargraphs.R")
source("plot/histograms.R")
source("plot/multiplot.R")
source("plot/null_graph.R")
source("plot/plot_styles.R")
source("plot/plotly-ize.R")
source("plot/scatterplots.R")
source("plotly/R/build_function.R")
source("plotly/R/colour_conversion.R")
source("plotly/R/corresp_one_one.R")
source("plotly/R/ggplotly.R")
source("plotly/R/marker_conversion.R")
source("plotly/R/plotly-package.r")
source("plotly/R/plotly.R")
source("plotly/R/signup.R")
source("plotly/R/tools.R")
source("plotly/R/trace_generation.R")
source("table/large_tables.R")
source("txt/help.R")
source("txt/notes.R")
source("txt/text_styles.R")

#############################################################################
# Prepping the dataframe after homogenizing names; not run after first time
#############################################################################
# to_fac <- c(2:4, 6, 7, 11, 12, 14:19, 21, 22, 47, 48)
# for (i in to_fac) {
#     full[,i] <- as.factor(full[,i])
#     full[,i] <- droplevels(full[,i])
# }

# mass_bad <- "(=rattlesnake), eastern massasauga"
# mass_good <- "Massasauga (=Rattlesnake), eastern"
# full$spp_ev_ls <- gsub(mass_bad, mass_good, full$spp_ev_ls, fixed=TRUE)
# spp_as_ls <- strsplit(full$spp_ev_ls, split="...", fixed=TRUE)
# sp_list <- sapply(spp_as_ls, strsplit, split="|", fixed=TRUE)
# sp_mat <- matrix(unlist(sp_list), ncol=2, byrow=TRUE)
# sp_ls_2 <- paste(sp_mat[,1], sp_mat[,2])
# species <- c("All", as.character(levels(as.factor(unlist(full$spp_ev_ls)))))
# full$spp_ev_ls <- strsplit(full$spp_ev_ls, split="...", fixed=TRUE)

# full$spp_ev_ls <- lapply(full$spp_ev_ls, 
#                          FUN=gsub,
#                          pattern="|",
#                          replacement=" ",
#                          fixed=TRUE)

# # Clean up the species BO string and make list
# spp_bo_sub <- gsub(")...", "): BO = ", full$spp_BO_ls, fixed=TRUE)
# spp_bo_sub <- gsub("...", "; CH = ", spp_bo_sub, fixed=TRUE)
# spp_bo_sub <- gsub("; CH = ; CH = ", " ", spp_bo_sub, fixed=TRUE)
# full$spp_BO_ls <- strsplit(spp_bo_sub, split="|", fixed=TRUE)

#############################################################################
# Load the data and basic data prep
#############################################################################

# save(full, file="data/FWS_consults_08-15_forDash_v1.RData")
# load("data/FWS_consults_08-15_forDash_v1.RData")

#############################################################################
# Load the data and basic data prep
#############################################################################
# load("data/FWS_consults_08-14_forDash.RData")
# load("data/FWS_consults_08-15_final_byConsult.RData")
# load("data/FWS_consults_08-15_forDash_v1.RData")
# load("data/FWS_S7_clean_data_postElapsed_fix.RData")
# load("data/FWS_S7_test.RData")
# load("data/FWS_S7_clean_15Jun2015.RData")
# load("data/FWS_S7_clean_23Jun2015.RData")
# load("data/FWS_S7_clean_15Jun2015.RData")
# load("data/FWS_S7_clean_11Jul2015.RData")

# load("data/FWS_S7_clean_15Jul2015_postSalmon.RData")
load("data/FWS_S7_clean_17Jul2015.RData")
species <- c("All", as.character(levels(as.factor(unlist(unlist(full$spp_ev_ls))))))

# dates <- c(8, 9, 10, 20)
# for (i in dates) {
#     full[[i]] <- as.character(full[[i]])
# }

# table to look up species-specific jeop/admod info
sp_look_f <- "data/jeop_admod_spp_table_12Jun2015.tab"
sp_ja_dat <- read.table(sp_look_f, sep="\t", header=T)

# data for ESFO-level map
eso_geo_fil <- "data/fieldOfficesTAILS.shp"
eso_geo_dat <- readShapePoly(eso_geo_fil, 
                             proj4string = CRS("+proj=merc +lon_0=90w"))

extent <- as.vector(bbox(eso_geo_dat))
xmin <- extent[1]
ymin <- extent[2]
xmax <- extent[3]
ymax <- extent[4]



#############################################################################
# Set plotly credentials
#############################################################################
set_credentials_file("jacob-ogre", "ykd3h99z9v")
