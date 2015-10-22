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

require(digest)
require(lubridate)

###############################################################################
# Load the data, rename the variables, then write RData file
###############################################################################
# Initial loading from tab'd file, then convert to RData for space and future
# loading.
basedir <- "~/OneDrive/Defenders/data/ESA_consultations/TABs/"
infile <- paste(basedir, "FWS_consults_08-14_filt_uniq_expand.tab", sep="")
dat <- read.table(infile,
                  stringsAsFactors=FALSE,
                  sep="\t",
                  header=TRUE)
# dim(dat)
# names(dat)

###############################################################################
# Do some type conversions
###############################################################################
to_factor <- c(1:8, 12:15, 17, 19:23, 25:38)
for(i in to_factor) {
    dat[,i] <- as.factor(dat[,i])
}

to_date <- c(9:11, 16, 24)
for(i in to_date) {
    dat[,i] <- as.Date(dat[,i])
}

# Drop n_days_due because it is empty...
dat <- dat[, -18]

###############################################################################
# Let's check some variables...
###############################################################################
# levels(dat[,1])
# levels(dat[,2])
# levels(dat[,3])
# length(levels(dat[,4])) # number of actions by ID
# length(levels(dat[,5])) # number of actions by action name (some repeats)
# levels(dat[,6])         # ARRA
# levels(dat[,7])
# summary(dat[,7])
# levels(dat[,8])
# summary(dat[,8])
# summary(dat[,9])
# summary(dat[,10])
# summary(dat[,11])
# levels(dat[,12])
# levels(dat[,13])
# levels(dat[,14])
# levels(dat[,15])
# summary(dat[,16])
# levels(dat[,17])
# levels(dat[,18])
# levels(dat[,19])
# levels(dat[,20])
# levels(dat[,21])
# summary(dat[,21])
# levels(dat[,22])
# summary(dat[,23])
# levels(dat[,24])
# length(levels(dat[,24]))
# summary(dat[,25])
# summary(dat[,26])
# summary(dat[,27])
# summary(dat[,28])
# summary(dat[,29])
# summary(dat[,30])
# summary(dat[,31])
# levels(dat[,32])

# These added here because they didn't convert for some reason...
dat$activity_code <- as.factor(dat$activity_code)
dat$spp_eval <- as.factor(tolower(dat$spp_eval))
dat$spp_BO <- as.factor(tolower(dat$spp_BO))

dat$work_category <- gsub("transport",
                          "transportation",
                          dat$work_category,
                          fixed=TRUE)

dat$work_category <- gsub("transportationation",
                          "transportation",
                          dat$work_category,
                          fixed=TRUE)

dat$work_category <- as.factor(dat$work_category)

# try to fix inconsistencies
dat$formal_consult <- ifelse(dat$formal_consult=="No" & (dat$Jeopardy==1 | dat$AdvMod==1),
                             "Yes",
                             as.character(dat$formal_consult))

dat$formal_consult <- as.factor(dat$formal_consult)

###############################################################################
# Write the "final" dataframe to file
###############################################################################
filtout <- "~/OneDrive/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-14_final.RData"
# save(dat, file=filtout)
load(filtout)

filtout2 <- "~/OneDrive/Defenders/data/ESA_consultations/TABs/FWS_consults_08-14_final.tab"
write.table(dat,
            file=filtout2,
            quote=FALSE,
            row.names=FALSE,
            sep="\t")


###############################################################################
# Make the consult-based data.frame
###############################################################################
dat$dat_sp_det <- paste(dat$spp_BO, 
                        dat$BO_determination, 
                        dat$CH_determination, sep="...")
dat$dups <- duplicated(dat$activity_code)
by_cons <- subset(dat, dat$dups==FALSE)
by_cons <- by_cons[,-52]

dat$keys <- paste(dat$activity_code, dat$spp_BO, sep="|")
dat$dups <- duplicated(dat$keys)
by_determ <- subset(dat, dat$dups==FALSE)
dim(by_determ)
names(by_determ)
by_determ <- by_determ[,-52:-53]
names(by_determ)

count_spp <- function(x) {
    len <- length(strsplit(as.character(x), split=",", fixed=TRUE)[[1]])
    return(len)
}

# Get the lists and counts of evaluated and BO species
spp_ev_ls <- tapply(as.factor(dat$spp_eval), 
                    INDEX=dat$activity_code, 
                    FUN=function(x) {levels(droplevels(x))})

spp_BO_ls <- tapply(as.factor(dat$dat_sp_det), 
                    INDEX=dat$activity_code, 
                    FUN=function(x) {levels(droplevels(x))})

new_df <- data.frame(row.names(spp_ev_ls), 
                         spp_ev_ls, 
                         spp_BO_ls)

names(new_df) <- c("activity_code",
                       "spp_ev_ls",
                       "spp_BO_ls")
row.names(new_df) <- seq(1, length(new_df$activity_code))

n_spp_eval <- apply(new_df$spp_ev_ls, MARGIN=1, FUN=count_spp)
n_spp_BO <- apply(new_df$spp_BO_ls, MARGIN=1, FUN=count_spp)
new_df <- data.frame(new_df, n_spp_eval, n_spp_BO)

# get the per-consultation counts
na_sum_fx <- function(x) {
    y <- as.numeric(as.character(x))
    res <- ifelse(length(y[!is.na(y)]) > 0,
                  sum(y, na.rm=TRUE),
                  NA)
    return(res)
}

na_sum_fx2 <- function(x) {
    res <- ifelse(length(x[!is.na(x)]) > 0,
                  sum(x, na.rm=TRUE),
                  NA)
    return(res)
}

n_nofx <- tapply(by_determ$NoEffect,
                 INDEX=by_determ$activity_code, 
                 FUN=na_sum_fx)

n_NLAA <- tapply(by_determ$NLAA,
                 INDEX=by_determ$activity_code, 
                 FUN=na_sum_fx)

n_conc <- tapply(by_determ$Concur,
                 INDEX=by_determ$activity_code, 
                 FUN=na_sum_fx)

n_jeop <- tapply(by_determ$Jeopardy,
                 INDEX=by_determ$activity_code, 
                 FUN=na_sum_fx)

tmp <- as.numeric(as.character(by_determ$RPA))
n_rpa <- tapply(tmp,
                INDEX=by_determ$activity_code, 
                FUN=sum, 
                na.rm=T)

n_admo <- tapply(by_determ$AdvMod,
                 INDEX=by_determ$activity_code, 
                 FUN=na_sum_fx)

n_tech <- tapply(by_determ$TechAssist, 
                 INDEX=by_determ$activity_code, 
                 FUN=na_sum_fx)

# combine the dataframes
new_df <- data.frame(new_df, n_nofx, n_NLAA, n_conc, n_jeop, n_rpa, n_admo, 
                     n_tech)

with_counts <- merge(x=by_cons, 
                     y=new_df, 
                     by.y="activity_code", 
                     by.x="activity_code")
dim(with_counts)

# #############################################################################
# # Get the jeopardy/AdMod consults
# #############################################################################
# of_interest <- subset(with_counts, n_jeop > 0 | n_admo > 0)
# to_drop <- c(51, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 33, 32, 31,
#              30, 29, 28, 27, 26, 25, 24, 12)
# for (i in to_drop) {
#     of_interest <- of_interest[,-i]
# }
# dim(of_interest)

# spp_ev_tx <- apply(of_interest$spp_ev_ls, MARGIN=1, FUN=toString)
# spp_BO_tx <- apply(of_interest$spp_BO_ls, MARGIN=1, FUN=toString)

# for_write <- of_interest
# for_write$spp_ev_ls <- spp_ev_tx
# for_write$spp_BO_ls <- spp_BO_tx

# ofinterest_fil <- "~/OneDrive/Defenders/data/ESA_consultations/TABs/jeopardy_admod_consults.tab"
# write.table(for_write, 
#             file=ofinterest_fil,
#             quote=FALSE,
#             row.names=FALSE,
#             sep="\t")


#############################################################################
#############################################################################
# Fix erroneous data
#
# The following activity_codes were determined by Keith Paul at FWS to have
# incorrect BO and/or CH determinations in TAILs; this loop simply sets the 
# n_jeop and n_admod--which are used for filtering in Shiny--to 0 for these
# consultations
#############################################################################
#############################################################################

# ofinterest_fil <- "~/OneDrive/Defenders/data/ESA_consultations/RDATAs/new_tally_dat.Rdata"
# save(with_counts, file=ofinterest_fil)

# by_consult <- with_counts

# bad_admod <- c("13260-2008-F-0004",
#                "13260-2008-F-0138",
#                "13260-2009-F-0016",
#                "13260-2009-F-0103",
#                "13260-2009-F-0110",
#                "13260-2009-F-0128",
#                "13260-2009-F-0153",
#                "13260-2011-F-0077",
#                "13260-2011-F-0098",
#                "14420-2010-F-0208",
#                "14421-2009-F-0097",
#                "65412-2011-F-0644",
#                "03E12000-2013-F-0546",
#                "03E12000-2013-F-0547",
#                "06E21000-2012-F-0887",
#                "33431-2009-F-0012",
#                "04EA1000-2012-F-0350",
#                "04EC1000-2013-F-0325",
#                "04EK1000-2012-F-0104",
#                "71470-2009-F-0209-R001",
#                "80211-2010-F-0007",
#                "52420-2009-F-0835",
#                "08FBDT00-2012-F-0026")

# for (i in bad_admod) {
#     by_consult$n_admo <- ifelse(by_consult$activity_code == i,
#                                 0,
#                                 by_consult$n_admo)
#     by_consult$n_jeop <- ifelse(by_consult$activity_code == i,
#                                 0,
#                                 by_consult$n_jeop)
#     by_consult$n_rpa <- ifelse(by_consult$activity_code == i,
#                                 0,
#                                 by_consult$n_rpa)
#     by_consult$spp_BO_ls <- ifelse(by_consult$activity_code == i,
#                                    gsub("Adverse Mod with RPA",
#                                         "No Adverse Mod",
#                                         by_consult$spp_BO_ls,
#                                         fixed=TRUE),
#                                    by_consult$spp_BO_ls)
#     by_consult$spp_BO_ls <- ifelse(by_consult$activity_code == i &
#                                    (i == "04EC1000-2013-F-0325" |
#                                     i == "06E21000-2012-F-0887" |
#                                     i == "52420-2009-F-0835"),
#                                    gsub("Jeopardy with RPA",
#                                         "Non-jeopardy",
#                                         by_consult$spp_BO_ls,
#                                         fixed=TRUE),
#                                    by_consult$spp_BO_ls)
#     by_consult$dat_sp_det <- ifelse(by_consult$activity_code == i &
#                                     (i != "81420-2008-F-1481" |
#                                      i != "41460-2008-F-0503"),
#                                    gsub("Adverse Modification",
#                                         "No Adverse Mod",
#                                         by_consult$dat_sp_det,
#                                         fixed=TRUE),
#                                    by_consult$dat_sp_det)
# }

#############################################################################
# winnow the dataframe
by_consult <- with_counts
names(by_consult)

to_drop <- c(51, 37, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 12)
names(by_consult)[to_drop]

for (i in to_drop) {
    by_consult <- by_consult[,-i]
}
dim(by_consult)
names(by_consult)

#############################################################################
# Fix the missing formal_consult entries
by_consult$formal_consult <- ifelse(by_consult$consult_type=="Formal Consultation" |
                                    by_consult$consult_type=="Formal Emergency Consultation",
                                    "Yes",
                                    "No")

# try to fix inconsistencies (again?!)
by_consult$formal_consult <- ifelse(by_consult$formal_consult=="No" & 
                                    (by_consult$n_jeop > 0 | by_consult$n_admo > 0),
                                    "Yes",
                                    as.character(by_consult$formal_consult))
by_consult$formal_consult <- as.factor(by_consult$formal_consult)

by_consult$consult_type <- ifelse(by_consult$formal_consult=="Yes" &
                                  by_consult$consult_type=="Informal Consultation",
                                  "Formal Consultation",
                                  as.character(by_consult$consult_type))
by_consult$consult_type <- as.factor(by_consult$consult_type)

# Write the current file because I need to do the combining before hashing staff
basedir <- "~/OneDrive/Defenders/data/ESA_consultations/"
filout <- paste(basedir, "RDATAs/FWS_consults_08-14_pre-hash.RData", sep="")
save(by_consult, file=filout)

###############################################################################
# Convert the species lists to char for writing the text file.
###############################################################################
spp_ev_tx <- apply(by_consult$spp_ev_ls, MARGIN=1, FUN=toString)
spp_BO_tx <- apply(by_consult$spp_BO_ls, MARGIN=1, FUN=toString)

spp_ev_ls <- gsub(pattern="\n", replace="", spp_ev_tx)
spp_BO_ls <- gsub(pattern="\n", replace="", spp_BO_tx)
spp_ev_ls <- gsub(pattern="\"", replace="", spp_ev_ls, fixed=T)
spp_BO_ls <- gsub(pattern="\"", replace="", spp_BO_ls, fixed=T)
spp_ev_ls <- gsub(pattern='c(', replace="", spp_ev_ls, fixed=T)
spp_BO_ls <- gsub(pattern='c(', replace="", spp_BO_ls, fixed=T)
spp_ev_ls <- gsub(pattern='))', replace=")", spp_ev_ls, fixed=T)
spp_BO_ls <- gsub(pattern='))', replace=")", spp_BO_ls, fixed=T)

for_write <- by_consult
for_write$spp_ev_ls <- spp_ev_ls
for_write$spp_BO_ls <- spp_BO_ls

filtout2 <- "~/OneDrive/Defenders/data/ESA_consultations/TABs/FWS_consults_08-14_semifinal_byConsult.tab"
write.table(for_write, 
            file=filtout2,
            quote=FALSE,
            row.names=FALSE,
            sep="\t")

#############################################################################
# Moved the hashing to the post-combining S5 code
# by_consult$staff_lead_hash <- rep("", length(by_consult$staff_lead))
# for (i in 1:length(by_consult$staff_lead_hash)) {                       
#     if (as.character(by_consult$staff_lead[i]) != "") {
#         by_consult$staff_lead_hash[i] <- digest(by_consult$staff_lead[i], "md5")
#     } else {
#         by_consult$staff_lead_hash[i] <- "None"
#     }
# }

# by_consult$staff_support_hash <- rep("", length(by_consult$staff_support))
# for (i in 1:length(by_consult$staff_support_hash)) {                       
#     if (as.character(by_consult$staff_support[i]) != "") {
#         by_consult$staff_support_hash[i] <- digest(by_consult$staff_support[i], "md5")
#     } else {
#         by_consult$staff_support_hash[i] <- "None"
#     }
# }

# by_consult$staff_lead_hash <- as.factor(by_consult$staff_lead_hash)
# by_consult$staff_support_hash <- as.factor(by_consult$staff_support_hash)

# by_consult <- by_consult[,-12]
# by_consult <- by_consult[,-8]

# # fix the dates issue for the jQuery table representation
# by_consult$start_date <- as.character(by_consult$start_date)
# by_consult$due_date <- as.character(by_consult$due_date)
# by_consult$FWS_concl_date <- as.character(by_consult$FWS_concl_date)
# by_consult$date_active_concl <- as.character(by_consult$date_active_concl)
# by_consult$date_formal_consult <- as.character(by_consult$date_formal_consult)

# filtout <- "~/OneDrive/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-14_final_byConsult.RData"
# save(by_consult, file=filtout)

# staff_hash <- data.frame(by_consult$staff_lead, by_consult$staff_lead_hash,
#                          by_consult$staff_support, by_consult$staff_support_hash)
# name_hash_out <- "~/OneDrive/Defenders/data/ESA_consultations/TABs/Sec7_staff_md5.tab"
# write.table(staff_hash, file=name_hash_out, quote=FALSE, row.names=FALSE, sep="\t")

