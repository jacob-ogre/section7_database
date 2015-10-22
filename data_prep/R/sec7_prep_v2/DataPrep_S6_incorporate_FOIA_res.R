# Integrates our manual consultation edits with the rest of the data.
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

df <- "~/Defenders_JWM/R/Sec7_dash/data/FWS_consults_08-15_forDash_v1.RData"
load(df)
dat <- full
bak <- dat

# OK, an early function call (in the prep process) messed up the informal label
# "No" in the formal_consult column, and the consult_type column for "Informal
# Consultation.  This fixes that problem.  And no, I don't understand why the
# earlier ifelse call did not work...
dat$formal_consult <- ifelse(is.na(dat$formal_consult),
                             "No",
                             as.character(dat$formal_consult))
dat$formal_consult <- as.factor(dat$formal_consult)

dat$consult_type <- ifelse(is.na(dat$consult_type),
                           "Informal Consultation",
                           as.character(dat$consult_type))
dat$consult_type <- as.factor(dat$consult_type)

dim(dat[dat$formal_consult=="Yes" & dat$consult_type=="Informal Consultation", ])
dim(dat[dat$formal_consult=="No" & dat$consult_type=="Formal Consultation", ])
dim(dat[is.na(dat$date_formal_consult) & dat$formal_consult=="Yes", ])
dim(dat[!is.na(dat$date_formal_consult) & dat$formal_consult=="No", ])
sum(is.na(dat$formal_consult))
sum(is.na(dat$consult_type))

###############################################################################
# Now for the part we actually want to solve:
base <- "~/OneDrive/Defenders/data/ESA_consultations/"
edited_data <- paste(base, "TABs/FOIA_to_update.tab", sep="")
to_delete <- paste(base, "reference_tabs/FOIA_BOs_to_remove.tab", sep="")

ed_dat <- read.table(edited_data,
                     sep="\t",
                     header=TRUE,
                     stringsAsFactors=FALSE)
ed_dat$FWS_concl_date <- as.character(as.Date(ed_dat$FWS_concl_date, format="%m/%d/%Y"))
ed_dat$start_date <- as.character(as.Date(ed_dat$start_date, format="%m/%d/%Y"))
ed_dat$date_formal_consult <- as.character(as.Date(ed_dat$date_formal_consult, 
                                                   format="%m/%d/%Y"))

to_del <- read.table(to_delete,
                     sep="\t",
                     header=TRUE,
                     stringsAsFactors=FALSE)

dat$FWS_concl_date <- as.character(dat$FWS_concl_date)
dat$start_date <- as.character(dat$start_date)
dat$date_formal_consult <- as.character(dat$date_formal_consult)
dim(dat)

# First drop the consultations that were removed during the FOIA editing
dels <- row.names(dat[dat$activity_code %in% to_del$activity_code &
                      !is.na(dat$activity_code), ])
keeps <- setdiff(row.names(dat), dels)
dat <- dat[keeps, ]
dim(dat)

# Now remove the updated consultations from dat and add in the new data
repl <- row.names(dat[dat$activity_code %in% ed_dat$activity_code &
                      !is.na(dat$activity_code), ])
keeps <- setdiff(row.names(dat), repl)
dat <- dat[keeps, ]
dim(dat)

dat <- rbind(dat, ed_dat)
dim(dat)

# Double-check Keith's list of BiOp corrections (manual); these are some 
# corrections
dat[dat$activity_code == "65412-2011-F-0644", ]$spp_BO_ls <- "least tern (sterna antillarum): BO = Non-jeopardy; CH = | pallid sturgeon (scaphirhynchus albus): BO = Non-jeopardy; CH = | piping plover (charadrius melodus): BO = Non-jeopardy; CH = | western prairie fringed orchid (platanthera praeclara): BO = Non-jeopardy; CH = | whooping crane (grus americana): BO = Non-jeopardy; CH = Non-jeopardy / No Adverse Modification"
dat[dat$activity_code == "65412-2011-F-0644", ]$n_rpa <- NA
dat[dat$activity_code == "65412-2011-F-0644", ]$n_admo <- 0

dat[dat$activity_code == "61411-2008-F-0364", ]$spp_BO_ls <- "bald eagle (haliaeetus leucocephalus): BO = Not Required - See Event Description; CH = , black-footed ferret (mustela nigripes): BO = NLAA - Concurrence Provided; CH = , blowout penstemon (penstemon haydenii): BO = Not Yet Determined; CH = , bonytail chub (gila elegans): BO = Non-jeopardy / No Adverse Modification; CH = , canada lynx (lynx canadensis): BO = NLAA - Concurrence Provided; CH = , colorado pikeminnow (=squawfish) (ptychocheilus lucius): BO = Non-jeopardy / No Adverse Modification; CH = , humpback chub (gila cypha): BO = Non-jeopardy / No Adverse Modification; CH = , kendall warm springs dace (rhinichthys osculus thermalis): BO = Not Yet Determined; CH = , least tern (sterna antillarum): BO = Not Yet Determined; CH = , pallid sturgeon (scaphirhynchus albus): BO = Not Yet Determined; CH = , piping plover (charadrius melodus): BO = Not Yet Determined; CH = , razorback sucker (xyrauchen texanus): BO = Non-jeopardy / No Adverse Modfication; CH = , ute ladies-tresses (spiranthes diluvialis): BO = Non-jeopardy; CH = , western prairie fringed orchid (platanthera praeclara): BO = Not Yet Determined; CH = , whooping crane (grus americana): BO = Not Yet Determined; CH = , yellow-billed cuckoo (coccyzus americanus): BO = Not Required - See Event Description; CH ="

# Save the dataframe at this point before fixing remaining issues.
mid_data <- paste(base, "RDATAs/FWS_S7_clean_data_preElapsed_fix.RData", sep="")
save(dat, file=mid_data)

# Fix one consult_type
dat$consult_type <- ifelse(as.character(dat$consult_type) == "Emergency Formal Consultation",
                           "Formal Emergency Consultation",
                           as.character(dat$consult_type))
dat$consult_type <- as.factor(dat$consult_type)

############################################################################
# Fix elapsed time
#
# Because of problems we noticed while reviewing the FOIA'd BiOps, we need to:
#   - set formal consultations with formal_start_data == end_date to NA
#   - calculate elapsed time for formals based on formal_start, not on start_date
#   - calculated elapsed for informals base on start_date
#
# Need to make sure this difference is noted in the S7 app!

bak <- dat
dat <- bak

dat$date_formal_consult <- as.Date(dat$date_formal_consult)
dat$start_date <- as.Date(dat$start_date)
dat$FWS_concl_date <- as.Date(dat$FWS_concl_date)

dat$date_form_num <- as.numeric(dat$date_formal_consult)
dat$date_start_num <- as.numeric(dat$start_date)
dat$date_concl_num <- as.numeric(dat$FWS_concl_date)

dat$elapsed <- ifelse(dat$formal_consult == "Yes",
                      ifelse(dat$date_form_num == dat$date_concl_num,
                             NA,
                             dat$date_concl_num - dat$date_form_num),
                      dat$date_concl_num - dat$date_start_num)

dat$elapsed <- ifelse(dat$elapsed < 0,
                      NA,
                      dat$elapsed)

# Save the dataframe at this point before fixing remaining issues.
el_data <- paste(base, "RDATAs/FWS_S7_clean_data_postElapsed_fix.RData", sep="")
save(dat, file=el_data)

bak2 <- dat
dat <- bak2

# Fix n_spp_BO
dat$n_spp_BO <- ifelse(nchar(dat$spp_BO_ls) < 5,
                       0,
                       dat$n_spp_BO)

# Save the dataframe at this point before fixing remaining issues.
el_data <- paste(base, "RDATAs/FWS_S7_clean_12Jun2015.RData", sep="")
save(dat, file=el_data)


