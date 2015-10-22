# More fixes of lead agencies.
# Copyright © 2015 Defenders of Wildlife, jmalcom@defenders.org

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

load("data/FWS_S7_clean_15Jun2015.RData")

# Fix the Forest Service issue:
full$lead_agency <- ifelse(full$lead_agency=="Forest Service" &
                           full$ESOffice=="NEW JERSEY ECOLOGICAL SERVICES FIELD OFFICE",
                           "NJ Forest Service",
                           as.character(full$lead_agency))
full$lead_agency <- as.factor(full$lead_agency)

# Fix the outstanding R3 issues:
rownames(full) <- full$activity_code

# no biop, set to null
no_biop <- c("03E13000-2013-F-0018", 
             "03E15000-2014-F-0380",
             "03E16000-2014-F-0003")
full <- full[!rownames(full) %in% no_biop, ]

withdraw <- c("32420-2008-F-0077",
              "32420-2011-F-0251")

full$FWS_concl_date <- ifelse(full$activity_code %in% withdraw,
                              NA,
                              as.character(full$FWS_concl_date))
full$FWS_concl_date <- as.Date(full$FWS_concl_date)

full$elapsed <- ifelse(full$activity_code %in% withdraw,
                       NA,
                       full$elapsed)

nojeop <- c("32420-2011-F-0424",
            "03E14000-2012-F-0024")

full["32420-2011-F-0424",]$spp_BO_ls <- "Wolf, gray (Canis lupus): BO = Non-jeopardy"
full["32420-2011-F-0424",]$spp_ev_ls <- "Wolf, gray (Canis lupus)"

#############################################################################
# Fix agency names
changes <- read.table("data/lead_agency_rev_data.tab",
                      sep="\t",
                      header=T,
                      stringsAsFactors=F)

names(changes) <- c("current_agency", "parenth")
to_upd <- changes[changes$parenth != "",]

bak <- full
full <- bak

full$lead_agency <- as.character(full$lead_agency)
for (i in 1:length(full$lead_agency)) {
    if (full$lead_agency[i] %in% c(to_upd$current_agency)) {
        cur_rec <- to_upd[to_upd$current_agency == full$lead_agency[i], ]
        new_agency <- paste(cur_rec$current_agency, " (",
                            cur_rec$parenth, ")",
                            sep="")
        full$lead_agency[i] <- new_agency
    }
}

full$lead_agency <- as.factor(full$lead_agency)

# full$lead_agency <- ifelse(as.character(full$lead_agency) %in% c(to_upd$current_agency),
#                            paste(to_upd$current_agency, " (",
#                                  to_upd$parenth, ")",
#                                  sep=""),
#                            as.character(full$lead_agency))
# head(full$lead_agency)

full$lead_agency <- ifelse(full$lead_agency == "Abandoned Mine Lands",
                           "WYOMING DEPARTMENT OF ENVIRONMENTAL QUALITY",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Council on Environmental Quality" &
                           full$ESOffice == "LOUISIANA ECOLOGICAL SERVICES FIELD OFFICE",
                           "Dept. Environmental Quality (LA)",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Council on Environmental Quality" &
                           full$ESOffice == "CORPUS CHRISTI ECOLOGICAL SERVICES FIELD OFFICE",
                           "Commission on Environmental Quality (TX)",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Council on Environmental Quality" &
                           full$ESOffice == "OKLAHOMA ECOLOGICAL SERVICES FIELD OFFICE",
                           "Dept. Environmental Quality (OK)",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Defense",
                           "Hawaii Army National Guard",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Environmental Management" &
                           full$ESOffice == "AUSTIN ECOLOGICAL SERVICES FIELD OFFICE",
                           "Department of Energy",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Environmental Management" &
                           full$ESOffice == "VENTURA FISH AND WILDLIFE OFFICE",
                           "Environmental Protection Agency",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Michigan Department of Natural Resources and Environment",
                           "Michigan Department of Natural Resources",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "NCDENR - Division of Water Quality",
                           "North Carolina Department of Environment and Natural Resources`",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "NCDENR - Land Quality Section",
                           "North Carolina Department of Environment and Natural Resources`",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Tennessee Valley Authority (Federal Government)",
                           "Tennessee Valley Authority",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(full$lead_agency == "Veterans Affairs Department",
                           "Department of Veterans Affairs",
                           as.character(full$lead_agency))

full$lead_agency <- ifelse(as.character(full$lead_agency) == "Game &amp; Fish Department",
                           "Game and Fish Department (ND)",
                           as.character(full$lead_agency))

full$lead_agency <- as.factor(full$lead_agency)

##############################################################################
# Fix the last of the jeopardy/admod errors
full[full$activity_code == "04EK1000-2014-F-0755",]$n_admo <- 0
full[full$activity_code == "04EK1000-2014-F-0755",]$n_rpa <- 0
full[full$activity_code == "04EK1000-2014-F-0755",]$spp_BO_ls <- "orangefoot pimpleback (pearlymussel) (plethobasus cooperianus): BO = Non-jeopardy / No Adverse Modification; CH = Not Yet Determined, rabbitsfoot (quadrula cylindrica cylindrica): BO = Non-jeopardy / No Adverse Modification; CH = Non-jeopardy / No Adverse Mod, sheepnose mussel (plethobasus cyphyus): BO = Non-jeopardy / No Adverse Modification; CH = Not Yet Determined)"

full[full$activity_code == "06E21000-2014-F-0363",]$n_admo <- 0
full[full$activity_code == "06E21000-2014-F-0363",]$n_rpa <- 0
full[full$activity_code == "06E21000-2014-F-0363",]$spp_BO_ls <- "topeka shiner (notropis topeka (=tristis): BO = No Adverse Modification; CH ="

# changing b/c certainly a typo
full[full$activity_code == "04ET1000-2014-F-0566",]$n_jeop <- 0
full[full$activity_code == "04ET1000-2014-F-0566",]$n_rpa <- 0
full[full$activity_code == "04ET1000-2014-F-0566",]$spp_BO_ls <- "blackside dace (phoxinus cumberlandensis): BO = Non-jeopardy; CH = OBSOLETE --- No Effect --, clubshell (pleurobema clava): BO = NLAA - Concurrence Provided; CH = OBSOLETE --- No Effect --, cumberland bean (pearlymussel) (villosa trabalis): BO = NLAA - Concurrence Provided; CH = OBSOLETE --- No Effect --, cumberland elktoe (alasmidonta atropurpurea): BO = Non-jeopardy; CH = No Adverse Modification, cumberland rosemary (conradina verticillata): BO = Not Required - See Event Description; CH = Not Required - See Event Description, cumberlandian combshell (epioblasma brevidens): BO = Non-jeopardy; CH = OBSOLETE --- No Effect --, dromedary pearlymussel (dromus dromas): BO = NLAA - Concurrence Provided; CH = Non-jeopardy / No Adverse Mod with RPA, duskytail darter (etheostoma percnurum): BO = Non-jeopardy; CH = OBSOLETE --- No Effect --, fluted kidneyshell (ptychobranchus subtentum): BO = NLAA - Concurrence Provided; CH = OBSOLETE --- No Effect - No Concurrence ---, littlewing pearlymussel (pegias fabula): BO = Non-jeopardy; CH = OBSOLETE --- No Effect --, oyster mussel (epioblasma capsaeformis): BO = Non-jeopardy; CH = No Adverse Modification, pink mucket (pearlymussel) (lampsilis abrupta): BO = Non-jeopardy; CH = OBSOLETE --- No Effect --, spectaclecase (mussel) (cumberlandia monodonta): BO = NLAA - Concurrence Provided; CH = OBSOLETE --- No Effect --, tan riffleshell (epioblasma florentina walkeri (=e. walkeri): BO = No Adverse Modification; CH = OBSOLETE --- No Effect --, virginia spiraea (spiraea virginiana): BO = NLAA - Concurrence Provided; CH = Not Required - See Event Description)"


##############################################################################
# Fix the dates yet again...
full$due_date <- as.Date(full$due_date, origin="1970-01-01")


save(full, file="data/FWS_S7_clean_11Jul2015.RData")

# Add in the state column
load("data/FWS_S7_clean_11Jul2015.RData")

st <- read.table("data/state_ESO_mappings.txt",
                 sep="\t",
                 header=FALSE)
names(st) <- c("state", "ESOffice")

new <- merge(full, st, by="ESOffice")
full <- new
save(full, file="data/FWS_S7_clean_11Jul2015_2.RData")

##############################################################################
# Some final fixes
full[full$activity_code == "05E2PA00-2013-I-0212", ]$lead_agency <- "-- OTHER: CONSULTANT --"
full[full$activity_code == "05E2VA00-2014-F-0209", ]$lead_agency <- "-- OTHER: CONSULTANT --"
full[full$activity_code == "52420-2009-F-0862", ]$lead_agency <- "-- OTHER: CONSULTANT --"

full[full$activity_code == "05E2PA00-2013-I-0212", ]$lead_agency
full[full$activity_code == "05E2VA00-2014-F-0209", ]$lead_agency
full[full$activity_code == "52420-2009-F-0862", ]$lead_agency

full$date_active_concl <- ifelse(full$date_active_concl == "1990-01-01",
                                 NA,
                                 full$date_active_concl)


