# Code for the formal analysis of FWS Section 7 data.
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

require(FactoMineR)
require(ggplot2)
require(lubridate)
source("~/Defenders_JWM/R/Sec7/multiplot.R")

cbbPalette <- c("#000000", 
                "#E69F00",
                "#56B4E9",
                "#009E73",
                "#F0E442",
                "#0072B2",
                "#D55E00",
                "#CC79A7",
                "#FFFFFF")

##############################################################################
# Load data
##############################################################################
# load("~/Dropbox/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-14_final_byConsult.RData")
# dat <- by_consult
load("Sec7_basic/data/FWS_S7_clean_01Jul2015.RData")
dat <- full

##############################################################################
# Summary statistics
##############################################################################
tally_01 <- function(x, y) {
    tmp <- table(x, y)
    zeroone <- ifelse(tmp > 0, 1, 0)
    return(rowSums(zeroone))
}

n_ESO_per_region <- tally_01(dat$region, dat$ESOffice)
n_staff_per_region <- tally_01(dat$region, dat$staff_lead_hash)
n_agencies_per_region <- tally_01(dat$region, dat$lead_agency)
n_consults_by_region <- table(dat$region)
n_formal_by_region <- table(dat[dat$formal=="Yes", ]$region)
pct_formal_by_region <- n_formal_by_region / n_consults_by_region
time_by_region <- tapply(dat$elapsed, 
                         INDEX=dat$region, 
                         FUN=mean, 
                         na.rm=TRUE)
n_spp_by_region <- tapply(dat$n_spp_eval, 
                          INDEX=dat$region, 
                          FUN=mean, 
                          na.rm=TRUE)

region_df <- data.frame(n_ESO_per_region, n_consults_by_region, 
                        n_staff_per_region,
                        n_formal_by_region, pct_formal_by_region, 
                        time_by_region, n_spp_by_region)
region_df <- region_df[,c(-2, -5, -7)]
names(region_df) <- c("n_ESO_per_region", "n_consults_by_region",
                      "n_staff_per_region",
                      "n_formal_by_region", "pct_formal_by_region",
                      "time_by_region", "n_spp_by_region")
region_df_full <- region_df
region_df <- region_df[-9,]

time_vs_n_consults <- ggplot(data=region_df, aes(n_consults_by_region,
                                                 time_by_region)) +
                      geom_point(aes(colour=rownames(region_df)), size=4) +
                      guides(colour=guide_legend(title="region")) +
                      scale_colour_manual(values=cbbPalette) +
                      labs(x="# consultations",
                           y="consultation time (days)")
time_vs_n_consults 

time_vs_n_formal <- ggplot(data=region_df, aes(n_formal_by_region,
                                               time_by_region)) +
                    geom_point(aes(colour=rownames(region_df)), size=4) +
                    guides(colour=guide_legend(title="region")) +
                    scale_colour_manual(values=cbbPalette) +
                    labs(x="# formal consultations",
                         y="consultation time (days)")
time_vs_n_formal 

mod1 <- lm(region_df$time_by_region ~ region_df$n_staff_per_region)
summary(mod1)

mod2 <- lm(region_df$time_by_region[-8] ~ region_df$n_staff_per_region[-8])
summary(mod2)

mod3 <- lm(time_by_region ~ n_staff_per_region + n_formal_by_region, 
           data=region_df)
summary(mod3)

mod4 <- lm(time_by_region ~ pct_formal_by_region, data=region_df)
summary(mod4)
resid(mod4)

region_df$time_formal_resid <- resid(mod4)

time_vs_n_staff <- ggplot(data=region_df, aes(n_staff_per_region,
                                              time_by_region)) +
                   geom_point(aes(colour=rownames(region_df)), size=4) +
                   guides(colour=guide_legend(title="region")) +
                   scale_colour_manual(values=cbbPalette) +
                   geom_abline(intercept=-5.1373, slope=0.3389) +
                   geom_abline(intercept=19.586, slope=0.06773, colour="red") +
                   labs(x="# staff per region",
                        y="consultation time (days)")
time_vs_n_staff

time_vs_n_staff2 <- ggplot(data=region_df, aes(n_staff_per_region,
                                              time_formal_resid)) +
                   geom_point(aes(colour=rownames(region_df)), size=4) +
                   guides(colour=guide_legend(title="region")) +
                   scale_colour_manual(values=cbbPalette) +
                   labs(x="# staff per region",
                        y="consultation time residuals (days)")
time_vs_n_staff2


##############################################################################
# Look at per-ESO relationships more closely
##############################################################################
n_staff_per_ESO <- tally_01(dat$ESOffice, dat$staff_lead_hash)
n_supp_staff_per_ESO <- tally_01(dat$ESOffice, dat$staff_support)
n_consults_by_ESO <- table(dat$ESOffice)
n_formal_by_ESO <- table(dat$ESOffice[dat$formal=="Yes"])
pct_formal_by_ESO <- n_formal_by_ESO / n_consults_by_ESO
time_by_ESO <- tapply(dat$elapsed, INDEX=dat$ESOffice, FUN=mean, na.rm=TRUE)

by_ESO <- data.frame(n_staff_per_ESO, n_supp_staff_per_ESO, n_consults_by_ESO,
                     n_formal_by_ESO, pct_formal_by_ESO, time_by_ESO)
by_ESO <- by_ESO[,c(-7, -5, -3)]
names(by_ESO) <- c("n_staff_per_ESO", "n_supp_staff_per_ESO", "n_consults_by_ESO",
                   "n_formal_by_ESO", "pct_formal_by_ESO", "time_by_ESO")
summary(by_ESO)

par(mfrow=c(2,3))
for (i in 1:length(by_ESO)) {
    hist(by_ESO[,i],
         xlab=names(by_ESO)[i],
         main="")
}

###############################################################################
# This is one to keep handy and/or refine
###############################################################################
pairs(~n_staff_per_ESO + n_supp_staff_per_ESO + n_consults_by_ESO +
      n_formal_by_ESO + pct_formal_by_ESO + time_by_ESO,
      data = by_ESO,
      main = "By ESOffice data")

cor(by_ESO)

ESO_pca <- PCA(by_ESO)
ESO_pca

pairs(ESO_pca$ind$coord)

mod1 <- lm(n_staff_per_ESO ~  pct_formal_by_ESO + n_formal_by_ESO + 
                              n_consults_by_ESO, data=by_ESO)
summary(mod1)

mod2 <- lm(n_staff_per_ESO ~  n_formal_by_ESO + n_consults_by_ESO, data=by_ESO)
summary(mod2)

mod3 <- lm(n_staff_per_ESO ~  n_formal_by_ESO, data=by_ESO)
summary(mod3)

mod4 <- lm(n_staff_per_ESO ~ n_consults_by_ESO + pct_formal_by_ESO, data=by_ESO)
summary(mod4)

mod5 <- lm((n_staff_per_ESO^2) ~  pct_formal_by_ESO + n_formal_by_ESO + 
                              n_consults_by_ESO, data=by_ESO)
summary(mod5)

AIC(mod1)
AIC(mod2)
AIC(mod3)
AIC(mod4)
AIC(mod5)

# Make a plot of the residuals, with point color by region
tmp <- data.frame(dat$region, dat$ESOffice)
names(tmp) <- c("region", "ESO")
tmp$combo <- paste(tmp$region, tmp$ESO, sep=";")
tmp$dups <- duplicated(tmp$combo)
ESO_region <- tmp[tmp$dups==FALSE,]
ESO_region <- ESO_region[order(ESO_region$ESO),]
ESO_region <- ESO_region[c(-10, -11, -12),]

mod2_df <- data.frame(by_ESO$n_formal_by_ESO, by_ESO$n_staff_per_ESO, 
                      resid(mod4), ESO_region, by_ESO$time_by_ESO,
                      by_ESO$pct_formal_by_ESO, by_ESO$n_consults_by_ESO)
mod2_df <- mod2_df[,c(-5, -6, -7)]
names(mod2_df) <- c("n_formal_by_ESO", "n_staff_by_ESO", "resid", "region", 
                    "time_by_ESO", "pct_formal_by_ESO", "n_consults_by_ESO")
mod2_df <- mod2_df[mod2_df$region != 9,]

# A plot of the residuals of the regression (this is a keeper):
n_cons_by_ESO_res <- ggplot(mod2_df, aes(n_formal_by_ESO, resid)) +
                     geom_point(aes(colour=region), alpha=0.5, size=4) +
                     stat_smooth() +
                     scale_colour_manual(values=cbbPalette) +
                     labs(x="# formal consultations",
                          y="# staff per ES Office (residuals)")
n_cons_by_ESO_res 

mod5 <- lm(n_staff_per_ESO ~  n_formal_by_ESO, data=mod2_df)
summary(mod5)

# And a plot of the basic regression with an abline:
n_cons_by_ESO <- ggplot(mod2_df, aes(n_formal_by_ESO, n_staff_by_ESO)) +
                     geom_point(aes(colour=region), alpha=0.5, size=4) +
                     geom_abline(intercept=10.535, slope=0.0851) +
                     geom_abline(intercept=8.079, slope=0.0851, colour="red") +
                     geom_abline(intercept=12.991, slope=0.0851, colour="red") +
                     scale_colour_manual(values=cbbPalette) +
                     labs(x="# formal consultations",
                          y="# staff per ES Office")
n_cons_by_ESO 

# followed by a plot with a square transform of n_staff:
n_cons_by_ESO <- ggplot(mod2_df, aes(n_formal_by_ESO, n_staff_by_ESO^2)) +
                     geom_point(aes(colour=region), alpha=0.5, size=4) +
                     geom_abline(intercept=20.42, slope=6.346, colour="red") +
                     scale_colour_manual(values=cbbPalette) +
                     labs(x="# formal consultations",
                          y="# staff per ES Office")
n_cons_by_ESO 

#######################
# Time
time_by_nFormal <- ggplot(mod2_df, aes(n_formal_by_ESO, time_by_ESO)) +
                   geom_point(aes(colour=region), alpha=0.5, size=4) +
                   # geom_abline(intercept=10.535, slope=0.0851) +
                   # geom_abline(intercept=8.079, slope=0.0851, colour="red") +
                   # geom_abline(intercept=12.991, slope=0.0851, colour="red") +
                   scale_colour_manual(values=cbbPalette) +
                   labs(x="# formal consultations",
                        y="Consultation time (days)")
time_by_nFormal

mod6 <- lm(time_by_ESO ~ pct_formal_by_ESO, data=mod2_df)
summary(mod6)
hist(resid(mod6)) #a little kurtosed...

mod7 <- lm(time_by_ESO ~ n_consults_by_ESO + n_formal_by_ESO + n_staff_by_ESO, 
           data=mod2_df)
summary(mod7)

AIC(mod6)
AIC(mod7)

# This is one of the keepers:
time_by_pctFormal <- ggplot(mod2_df, aes(pct_formal_by_ESO, time_by_ESO)) +
                     geom_point(aes(colour=region), alpha=0.5, size=4) +
                     geom_abline(intercept=26.537, slope=81.958) +
                     geom_abline(intercept=19.417, slope=81.958, colour="red") +
                     geom_abline(intercept=33.657, slope=81.958, colour="red") +
                     scale_colour_manual(values=cbbPalette) +
                     labs(x="% formal consultations",
                          y="Consultation time (days)")
time_by_pctFormal

mod8 <- lm(time_by_ESO ~ n_staff_by_ESO, data=mod2_df)
summary(mod8)

mean_time <- mean(mod2_df$time_by_ESO, na.rm=TRUE)
time_by_nPerson <- ggplot(mod2_df, aes(n_staff_by_ESO, time_by_ESO)) +
                   geom_point(aes(colour=region), alpha=0.5, size=4) +
                   geom_abline(intercept=23.8286, slope=0.8218) +
                   geom_hline(yintercept=mean_time, colour="red") +
                   # geom_abline(intercept=12.991, slope=0.0851, colour="red") +
                   scale_colour_manual(values=cbbPalette) +
                   labs(x="# staff",
                        y="Consultation time (days)")
time_by_nPerson

mod9 <- lm(time_by_ESO ~ n_formal_by_ESO, data=mod2_df)
summary(mod9)
mod2_df$time_formal_resid <- resid(mod9)

mod10 <- lm(time_formal_resid ~ n_staff_by_ESO, data=mod2_df)
summary(mod10)

time_resid_person <- ggplot(mod2_df, aes(n_staff_by_ESO, time_formal_resid)) +
                     geom_point(aes(colour=region), alpha=0.5, size=4) +
                     geom_abline(intercept=1.072, slope=-0.061) +
                     scale_colour_manual(values=cbbPalette) +
                     labs(x="# staff",
                          y="Consultation time residuals (days)")
time_resid_person

ratio_time_resid_person <- mod2_df$time_formal_resid / mod2_df$n_staff_by_ESO 

tmp_df <- data.frame(rownames(mod2_df), ratio_time_resid_person, 
                     mod2_df$time_formal_resid, mod2_df$n_staff_by_ESO, 
                     mod2_df$n_consults_by_ESO, mod2_df$pct_formal_by_ESO)
tmp_df[order(tmp_df$ratio_time_resid_person),]

write.table(tmp_df, 
            file="~/Dropbox/Defenders/data/ESA_consultations/tmp_table.tab",
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

##############################################################################
# Look at FWS employee-level effects
##############################################################################
time_per_person <- tapply(dat$elapsed, INDEX=dat$staff_lead_hash, FUN=mean, na.rm=TRUE)
mean_time <- mean(dat$elapsed, na.rm=TRUE)
se_time <- sd(dat$elapsed) / sqrt(length(dat$elapsed))
over_time_person <- time_per_person[time_per_person > (mean_time + 2*se_time)]
under_time_person <- time_per_person[time_per_person < (mean_time + 2*se_time)]

time_mod1 <- lm(elapsed ~ staff_lead_hash + formal_consult + n_spp_eval + region,
                data=dat)
summary(time_mod1)
hist(resid(time_mod1))
time_amod1 <- aov(time_mod1)
summary(time_amod1)

# Drop the most-extreme 2% of records and run regression...
subt <- subset(dat, dat$elapsed < quantile(dat$elapsed, 0.98, na.rm=TRUE))
time_mod2 <- lm(elapsed ~ staff_lead_hash + formal_consult + n_spp_eval + region,
                data=subt)
summary(time_mod2)
hist(resid(time_mod2))
time_amod2 <- aov(time_mod2)
summary(time_amod2)

formal_time <- lm(elapsed ~ formal_consult, data=dat)
summary(formal_time)
summary(aov(formal_time))

formal_time_spp <- lm(elapsed ~ formal_consult + n_spp_eval, data=dat)
summary(formal_time_spp)
dat$formal_time_spp_resid <- resid(formal_time_spp)

time_resid_per_person <- tapply(dat$formal_time_spp_resid, 
                                INDEX=dat$staff_lead_hash, 
                                FUN=mean, 
                                na.rm=TRUE)
sort(time_resid_per_person)[1:10]
sort(time_resid_per_person, decreasing=TRUE)[1:10]

# This is actually the global model
time_mod3 <- lm(elapsed ~ staff_lead_hash + formal_consult + FY + n_spp_eval +
                          consult_complex + work_category,
                data=subt)
hist(resid(time_mod3))
time_amod3 <- aov(time_mod3)
summary(time_mod3)
summary(time_amod3)

#OK, I need to make dataframe that is of the right form to analyze ind. effects

dur_reg_mod <- lm(elapsed ~ region, data=dat[dat$formal=="Yes",])
summary(dur_reg_mod)

formals <- dat[dat$formal=="Yes",]
long <- formals$elapsed[formals$elapsed > 135]
sum(!is.na(long))



# 23 Jun 2015 and afterwards
formal <- dat[dat$formal_consult=="Yes" & !is.na(dat$formal_consult),]
mod1 <- lm(elapsed ~ region, data=formal)
summary(mod1)



# I need to try to get CIs for median times...
med_CI <- function(x, conf=1.96) {
    med <- median(x, na.rm=TRUE)
    no_na <- x[!is.na(x)]
    n <- length(no_na)
    lcl_rank <- round((n / 2) - ((conf * sqrt(n)) / 2), 0)
    ucl_rank <- round(1 + (n / 2) + ((conf * sqrt(n)) / 2), 0)
    sort_x <- sort(no_na, na.last=TRUE)
    ranks <- rank(sort_x)
    tmpd <- data.frame(sort_x, ranks)
    tmpd <- tmpd[!is.na(tmpd$sort_x), ]
    lcl_near <- which.min(abs(tmpd$ranks - lcl_rank))
    ucl_near <- which.min(abs(tmpd$ranks - ucl_rank))
    lcl_value <- unique(tmpd[lcl_near,]$sort_x)
    ucl_value <- unique(tmpd[ucl_near,]$sort_x)
    return(list(lcl=lcl_value, med=med, ucl=ucl_value))
}
med_CI(full$elapsed, conf=3.291)
med_CI(full$elapsed, conf=5.998)
med_CI(full[full$formal_consult=="Yes",]$elapsed)

med_CI(full[full$consult_complex == "Programmatic Program-Level",]$elapsed)
med_CI(full[full$consult_complex == "Programmatic Program-Level" &
            full$formal_consult == "Yes",]$elapsed)
    
med_CI(full[full$consult_complex == "Programmatic Project-Level",]$elapsed)
med_CI(full[full$consult_complex == "Programmatic Project-Level" &
            full$formal_consult == "Yes",]$elapsed)

plot(log(full$elapsed+0.1) ~ as.numeric(as.character(full$FY)))
summary(lm(log(full$elapsed+0.1) ~ as.numeric(as.character(full$FY))))
summary(lm(full$elapsed ~ as.numeric(as.character(full$FY))))

n_per_yr <- table(full$FY)
mean_time_yr <- tapply(full$elapsed, INDEX=full$FY, FUN=mean, na.rm=T)
plot(as.vector(mean_time_yr) ~ as.vector(n_per_yr))

summary(lm(n_per_yr ~ as.numeric(as.character(names(n_per_yr)))))

