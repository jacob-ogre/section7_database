# analyze_query.R
# Summary statistics and figures for Sec7 db queries.
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

require(ggplot2)

###############################################################################
# TEMP
###############################################################################
# load("FWS_consultations_2008-2014.RData")
# dat <- full

###############################################################################
# Functions
###############################################################################
# my_barplot <- function(x, main, ylab, xorient, bottom) {
#     if (bottom < 2.5) {
#         bottom = 2.5
#     }
#     par(mar=c(bottom,5.5,2,2), mgp=c(3.5,1,0))
#     barplot(x,
#             space=0.1,
#             border=NA,
#             las=xorient,
#             cex.axis=0.8,
#             main=main,
#             ylab=ylab,
#             col="darkolivegreen4")
#     box(col="gray55")
# }

# my_barplot(a, "FWS region", "# consultations", 1, 2.5)

###############################################################################
# Load data and do basic data management
###############################################################################
dat <- read.table("query_results.tab",
                  sep="\t",
                  header=FALSE,
                  stringsAsFactors=FALSE)

newnames <- c("region", "ESOffice", "FY", "activity_code",
              "title", "activity_type",
              "status", "ARRA", "lead_agency", "staff_lead", 
              "start_date", "due_date", "FWS_concl_date", "spp_eval", 
              "staff_support", "support_agency", "FY_start", "FY_concl", 
              "active_concl", "date_active_concl", "timely_concl", 

              "n_days_elapsed", "n_days_due", "hours_logged", 
              "events_logged", "no_FWS_performed", "formal_consult", 
              "consult_type", "consult_complex", "date_formal_consult", 
              "withdrawn", "spp_BO", "BO_determination", 
              "CH_determination", "CH_flag", "take", "work_type",

              "work_category", "performance", "datum", "lat_dec_deg",
              "long_dec_deg", "lat_deg", "lat_min", "lat_sec",
              "long_deg", "long_min", "long_sec", "UTM_E",
              "UTM_N", "UTM_zone")
names(dat) <- newnames

to_factor <- c(1:10, 14:17, 19, 21, 24:35, 38)
for(i in to_factor) {
    dat[,i] <- as.factor(dat[,i])
}

to_date <- c(11:13, 20)
for(i in to_date) {
    dat[,i] <- as.Date(dat[,i])
}

parts <- strsplit(x=dat[,37], split=" - ")
Action.Category <- sapply(parts, "[", 1)
dat <- data.frame(dat[,1:37], Action.Category, dat[,38:length(dat)])

###############################################################################
# Summary stats
###############################################################################
n_consults <- length(levels(dat$activity_code))
n_records <- length(dat$title)
n_ESFO <- length(levels(dat$ESOffice))
n_personnel <- length(levels(dat$staff_lead))
n_agencies <- length(levels(dat$lead_agency))
n_spp_eval <- length(levels(dat$spp_eval))
n_spp_BO <- length(levels(dat$spp_BO))

stats <- c(n_records, n_consults, n_ESFO, n_personnel, n_agencies, n_spp_eval,
           n_spp_BO)
stats_df <- data.frame(stats)
row.names(stats_df) <- c("N_records", "N_consult", "N_ESFO", "N_personnel", 
                         "N_agencies", "N_spp_eval", "n_spp_BO")
stats_df

write.table(stats_df,
            file="query_stats.tab",
            col.names=FALSE,
            quote=FALSE,
            sep="\t")

###############################################################################
# Plots
###############################################################################
#----------------------
# Region summary
#----------------------
png(file="figures/region_barplot.png")
ggplot(dat, aes(region)) +
    geom_bar(fill="darkolivegreen4") + 
    xlab("FWS region")
garbage <- dev.off()

#----------------------
# formal/informal
#----------------------
png(file="figures/consult_type_barplot.png")
ggplot(dat, aes(consult_type)) +
    geom_bar(fill="darkolivegreen4") + 
    xlab("Action category (top 10)") + 
    theme(axis.text.x=element_text(angle=40, vjust=1, hjust=1))
garbage <- dev.off()

#----------------------
# complexity
#----------------------
png(file="figures/complexity_barplot.png")
ggplot(dat, aes(consult_complex)) +
    geom_bar(fill="darkolivegreen4") + 
    xlab("Consultation complexity") + 
    theme(axis.text.x=element_text(angle=40, vjust=1, hjust=1))
garbage <- dev.off()

#----------------------
# FY
#----------------------
pdf(file="figures/FY_barplot.pdf")
ggplot(dat, aes(FY)) +
    geom_bar(fill="darkolivegreen4") + 
    xlab("Fiscal year") + 
    theme(axis.text.x=element_text(angle=40, vjust=1, hjust=1))
garbage <- dev.off()

#----------------------
# BO determination
#----------------------
BO_cat <- table(dat$BO_determination)
if (length(BO_cat) > 10) {
    BO_cat <- sort(BO_cat)[(length(BO_cat)-10):length(BO_cat)]
}
a_sub <- subset(dat, dat$BO_determination %in% names(BO_cat))
# dim(a_sub)

png(file="figures/BO_determination_barplot.png", height=8, width=10)
ggplot(a_sub, aes(x=reorder(BO_determination, 
                            BO_determination, 
                            function(x)-length(x)))) +
    geom_bar(fill="darkolivegreen4") + 
    xlab("BO determination (top 10)") + 
    theme(axis.text.x=element_text(angle=50, vjust=1, hjust=1))
garbage <- dev.off()

#----------------------
# action categories (top 5)
#----------------------
CH_det_cat <- table(dat$CH_determination)
CH_det_cat <- CH_det_cat[-length(CH_det_cat)]
if (length(CH_det_cat) > 10) {
    CH_det_cat <- sort(CH_det_cat)[(length(CH_det_cat)-10):length(CH_det_cat)]
}
a_sub <- subset(dat, dat$CH_determination %in% names(CH_det_cat) &
                dat$CH_determination != "")

if (dim(a_sub)[1] > 0) {
    png("figures/CH_determination_barplot.png")
    ggplot(a_sub, aes(x=reorder(CH_determination, 
                                CH_determination, 
                                function(x)-length(x)))) +
        geom_bar(fill="darkolivegreen4") + 
        xlab("CH determinations (top 10)") + 
        theme(axis.text.x=element_text(angle=50, vjust=1, hjust=1))
    garbage <- dev.off()
}

#----------------------
# time required   
#----------------------
elapsed <- as.numeric(dat$date_active_concl - dat$start_date)
dat <- data.frame(dat, elapsed)

png(file="figures/time_hist.png")
ggplot(dat[dat$elapsed < quantile(dat$elapsed, 0.95),], 
    aes(x=elapsed)) +
    geom_histogram(fill="darkolivegreen4") +
    xlab("Consultation duration (days)") +
    geom_vline(xintercept=31, 
               color="darkgoldenrod3", 
               linetype="longdash") +
    geom_vline(xintercept=median(dat$elapsed),
               color="darkgoldenrod3", 
               linetype="solid") +
    geom_vline(xintercept=206.9, 
               color="firebrick4", 
               linetype="longdash") +
    geom_vline(xintercept=mean(dat$elapsed),
               color="firebrick4", 
               linetype="solid")
garbage <- dev.off()









