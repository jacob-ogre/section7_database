# Code to clean the (probably ugly) new consultation data.
# Copyright (c) 2016 Defenders of Wildlife, jmalcom@defenders.org

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
# 

library(digest)
library(plyr)
library(dplyr)
library(readr)

##########################################################################
# Load the data
##########################################################################

base <- "/Users/jacobmalcom/Dropbox/TAILS data/"
file = paste0(base, "/extracted/new_data_raw.tsv")

data <- read_tsv(file)
head(data)
dim(data)

base2 <- "/Users/jacobmalcom/Repos/Defenders/section7_database/defenders_sec7_shiny/data/"
load(paste0(base2, "FWS_S7_clean_30Jul2015.RData"))
orig <- full
rm(full)
dim(orig)

##########################################################################
# Let's get some summaries
##########################################################################
get_summaries <- function(x) {
    for (i in 1:length(x)) {
        cur_var <- x[[i]]
        cat(paste0("Variable: ", names(x)[i], "\n"))
        if (is.factor(cur_var)) {
            n_levels <- length(levels(cur_var))
            cat(paste0("\t\tFactor with ", n_levels, " levels\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(levels(cur_var)), "\n"))
        } else if (is.numeric(cur_var)) {
            cat(paste0("\tNumeric\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(levels(cur_var)), "\n"))
            cat(paste0("\tMean:", mean(cur_var), "\n"))
        } else if (is.character(cur_var)) {
            cat(paste0("\tCharacter\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(cur_var), "\n"))
        } else {
            cat(paste0("\t????\n"))
            cat("\tFor example:\n")
            cat(paste0("\t\t", head(cur_var), "\n"))
        }
        cat("\n=======================\n\n")
    }
}
get_summaries(data)

##############################################################################
# Fix up the variable names...
##############################################################################
orig_name <- names(orig)
data_name <- names(data)

head(data_name, 30)
tail(data_name, 25)
head(orig_name, 20)

data_names <- c("region", "ESOffice", "FY", "activity_code",
                "title", "activity_type", "status", "ARRA",
                "lead_agency", "staff_lead", "start_date", "due_date",
                "FWS_concl_date", "spp_ev", "staff_support", "support_agency",
                "datum", "lat_dec_deg", "long_dec_deg", "lat_deg", 
                "lat_min", "lat_sec", "long_deg", "long_min", 
                "long_sec", "UTM_E", "UTM_N", "UTM_zone", 
                "FY_start", "FY_concl", "active", "timely_concl",
                "elapsed", "due_days", "hours_logged", "events_logged",
                "FWS_no_work", "formal_consult", "consult_type", "consult_complex",
                "date_formal_consult", "withdrawn", "spp_BO", "BO_determin",
                "CH_determin", "CH_flag", "take", "work_type", "perf_category")
length(data_names)
names(data) <- data_names

names(orig)
names(data)

##############################################################################
# Make new variables for the df
##############################################################################

# First the place data collapse
base3 <- "/Users/jacobmalcom/Repos/Defenders/section7_database/data_prep/R/sec7_prep_v3/"
st_ESO <- read_tsv(paste0(base3, "state_ESO_mappings.tsv"))

ESOffice <- tapply(data$ESOffice,
                   INDEX = data$activity_code,
                   FUN = unique)
region <- tapply(data$region,
                 INDEX = data$activity_code,
                 FUN = unique)

ESO_df <- data.frame(activity_code = names(ESOffice),
                     ESOffice = as.vector(ESOffice))
reg_df <- data.frame(activity_code = names(region),
                     region = as.vector(region))

state <- merge(ESO_df, st_ESO, by="ESOffice")
place <- merge(state, reg_df, by="activity_code")
head(place)
place <- place[, c(1, 4, 3, 2)]

by_activity <- function(x) {
    clr <- function(x) {
        ifelse(identical(x, character(0)),
               NA,
               as.character(x))
    }
    res <- tapply(x,
                  INDEX = data$activity_code,
                  FUN = function(x) {(unique(x[!is.na(x)]))} )
    res <- lapply(res, FUN=clr)
    if (length(res) != 11220) {
        print("non-uniques")
    }
    return(res)
}

title <- by_activity(data$title)
lead_agency <- by_activity(data$lead_agency)
FY <- by_activity(data$FY)
FY_start <- by_activity(data$FY_start)
FY_concl <- by_activity(data$FY_concl)
start_date <- by_activity(data$start_date)
date_formal_consult <- by_activity(data$date_formal_consult)
due_date <- by_activity(data$due_date)
FWS_concl_date <- by_activity(data$FWS_concl_date)
elapsed <- by_activity(data$elapsed)
timely_concl <- by_activity(data$timely_concl)
hours_logged <- by_activity(data$hours_logged)
events_logged <- by_activity(data$events_logged)
formal_consult <- by_activity(data$formal_consult)
consult_type <- by_activity(data$consult_type)
consult_complex <- by_activity(data$consult_complex)
work_type <- by_activity(data$work_type) # need to make work_category!
ARRA <- by_activity(data$ARRA)
datum <- by_activity(data$datum)
lat_dec_deg <- by_activity(data$lat_dec_deg)
long_dec_deg <- by_activity(data$long_dec_deg)
lat_deg <- by_activity(data$lat_deg)
lat_min <- by_activity(data$lat_min)
lat_sec <- by_activity(data$lat_sec)
long_deg <- by_activity(data$long_deg)
long_min <- by_activity(data$long_min)
long_sec <- by_activity(data$long_sec)
UTM_E <- by_activity(data$UTM_E)
UTM_N <- by_activity(data$UTM_N)
UTM_zone <- by_activity(data$UTM_zone)


######################
# species lists
make_spp_ls <- function(x, y) {
    res <- tapply(x,
                  INDEX = y,
                  FUN = function(z) { unlist(list(unique(z))) })
    return(res)
}

spp_ev_ls <- make_spp_ls(data$spp_ev, data$activity_code)
spp_ev_df <- data.frame(activity_code = names(spp_ev_ls),
                        spp_ev_ls = spp_ev_ls)

spp_BO_ls <- make_spp_ls(data$spp_BO, data$activity_code)
spp_BO_df <- data.frame(activity_code = names(spp_BO_ls),
                        spp_BO_ls = spp_BO_ls)

data$spp_BO_det <- ifelse(!is.na(data$spp_BO),
                          paste0(data$spp_BO, 
                                 ": BO = ", 
                                 data$BO_determin, 
                                 "; CH = ",
                                 data$CH_determin),
                          " ")
spp_BOdet <- make_spp_ls(data$spp_BO_det, data$activity_code)
spp_BOddf <- data.frame(activity_code = names(spp_BOdet),
                        spp_BOdet = spp_BOdet)

n_spp_ev <- tapply(spp_ev_df$spp_ev_ls,
                   INDEX=spp_ev_df$activity_code, 
                   FUN=function(x) length(strsplit(x[[1]], split=",", fixed=T)))
head(n_spp_ev)

n_spp_ev <- data.frame(activity_code = names(n_spp_ev),
                       n_spp_ev = as.vector(n_spp_ev))

spp_dat <- merge(spp_ev_df, spp_BOddf, by="activity_code")
spp_dat <- merge(spp_dat, n_spp_ev, by="activity_code")

#######################
# determinations

base3 <- "/Users/jacobmalcom/Repos/Defenders/section7_database/data_prep/R/sec7_prep_v3/"
dmap <- read_tsv(paste0(base3, "Workbook1.txt"))
dmap[1,1] <- NA
dmap[1,2] <- NA
dmap[6,2] <- NA
names(dmap) <- c("BO_determin", "det_map")
dmap$CH_determin <- dmap$BO_determin

dmap$BO_determin <- gsub(x=dmap$BO_determin, 
                         pattern='\"',
                         replacement='',
                         fixed=TRUE)
dmap$CH_determin <- gsub(x=dmap$CH_determin, 
                         pattern='\"',
                         replacement='',
                         fixed=TRUE)

combo1 <- paste(data$activity_code, data$spp_BO)
tmp <- cbind(data, combo1)
tmp$uniq <- duplicated(tmp$combo1)
t2 <- tmp[tmp$uniq == FALSE, ]
unique(t2$BO_determin)

t3 <- merge(t2, dmap, by="BO_determin")
table(t3$det_map)

t4 <- merge(t2, dmap, by="CH_determin")
table(t4$det_map)

jsub <- t3[t3$det_map == "JEOP" & !is.na(t3$det_map), ]
amsub <- t4[t4$det_map == "AM" & !is.na(t4$det_map), ]
lsub <- t3[t3$det_map == "LAA" & !is.na(t3$det_map), ]
nlsub <- t3[t3$det_map == "NLAA" & !is.na(t3$det_map), ]
nesub <- t3[t3$det_map == "NE" & !is.na(t3$det_map), ]
tsub <- t3[t3$det_map == "TA" & !is.na(t3$det_map), ]

n_jeop <- tapply(jsub$det_map,
                 INDEX=jsub$activity_code,
                 FUN=length)
nojeop <- setdiff(unique(data$activity_code), names(n_jeop))
nojena <- rep(0, length(nojeop))
nojedf <- data.frame(activity_code=nojeop, n_jeop=nojena)
n_jeop <- data.frame(activity_code=names(n_jeop), n_jeop=as.vector(n_jeop))
n_jeop <- rbind(n_jeop, nojedf)
dim(n_jeop)

n_admo <- tapply(amsub$det_map,
                 INDEX=amsub$activity_code,
                 FUN=length)
noadmo <- setdiff(unique(data$activity_code), names(n_admo))
noamna <- rep(0, length(noadmo))
noamdf <- data.frame(activity_code=noadmo, n_admo=noamna)
n_admo <- data.frame(activity_code=names(n_admo), n_admo=as.vector(n_admo))
n_admo <- rbind(n_admo, noamdf)
dim(n_admo)

n_laa <- tapply(lsub$det_map,
                INDEX=lsub$activity_code,
                FUN=length)
nolaa <- setdiff(unique(data$activity_code), names(n_laa))
nolana <- rep(0, length(nolaa))
noladf <- data.frame(activity_code=nolaa, n_laa=nolana)
n_laa <- data.frame(activity_code=names(n_laa), n_laa=as.vector(n_laa))
n_laa <- rbind(n_laa, noladf)
dim(n_laa)

n_nlaa <- tapply(nlsub$det_map,
                 INDEX=nlsub$activity_code,
                 FUN=length)
nonlaa <- setdiff(unique(data$activity_code), names(n_nlaa))
nonlna <- rep(0, length(nonlaa))
nonldf <- data.frame(activity_code=nonlaa, n_nlaa=nonlna)
n_nlaa <- data.frame(activity_code=names(n_nlaa), n_nlaa=as.vector(n_nlaa))
n_nlaa <- rbind(n_nlaa, nonldf)
dim(n_nlaa)

n_ne <- tapply(nesub$det_map,
               INDEX=nesub$activity_code,
               FUN=length)
none <- setdiff(unique(data$activity_code), names(n_ne))
nonena <- rep(0, length(none))
nonedf <- data.frame(activity_code=none, n_ne=nonena)
n_ne <- data.frame(activity_code=names(n_ne), n_ne=as.vector(n_ne))
n_ne <- rbind(n_ne, nonedf)
dim(n_ne)

n_ta <- tapply(tsub$det_map,
               INDEX=tsub$activity_code,
               FUN=length)
nota <- setdiff(unique(data$activity_code), names(n_ta))
notana <- rep(0, length(nota))
notadf <- data.frame(activity_code=nota, n_ta=notana)
n_ta <- data.frame(activity_code=names(n_ta), n_ta=as.vector(n_ta))
n_ta <- rbind(n_ta, notadf)
dim(n_ta)

determ_counts <- n_jeop
determ_counts$activity_code <- as.character(determ_counts$activity_code)
counts <- list(n_admo, n_laa, n_nlaa, n_ne, n_ta)
for (i in counts) {
    i$activity_code <- as.character(i$activity_code)
    determ_counts <- merge(determ_counts, i, by = "activity_code")
}
dim(determ_counts)

############################################################################
# Need to hash the biologists' names
############################################################################

hash_names <- function(x) {
    if(as.character(x) != "" & !is.na(x)) {
        return(digest(x, "md5"))
    } else {
        return("None")
    }
}

data$staff_lead_hash <- unlist(lapply(data$staff_lead, FUN = hash_names))
data$staff_support_hash <- unlist(lapply(data$staff_support, FUN = hash_names))

staff_hash_tab <- tapply(data$staff_lead_hash,
                         data$activity_code,
                         FUN = unique)
staff_hash_df <- data.frame(activity_code = names(staff_hash_tab),
                            staff_lead_hash = as.vector(staff_hash_tab))

stsup_hash_tab <- tapply(data$staff_support_hash,
                         data$activity_code,
                         FUN = function(x) {paste(unique(x), collapse="; ")})
stsup_hash_df <- data.frame(activity_code = names(stsup_hash_tab),
                            staff_support_hash = as.vector(stsup_hash_tab))

############################################################################
# Now to put the pieces together
############################################################################
dim(place)

fields <- list(title, lead_agency, FY, FY_start, FY_concl, start_date, 
               date_formal_consult, due_date, FWS_concl_date, elapsed, 
               timely_concl, hours_logged, events_logged, formal_consult, 
               consult_type, consult_complex, work_type, ARRA, 
               datum, lat_dec_deg, long_dec_deg, lat_deg, lat_min, lat_sec, 
               long_deg, long_min, long_sec, UTM_E, UTM_N, UTM_zone)

fnames <- list("title", "lead_agency", "FY", "FY_start", "FY_concl", "start_date", 
               "date_formal_consult", "due_date", "FWS_concl_date", "elapsed", 
               "timely_concl", "hours_logged", "events_logged", "formal_consult", 
               "consult_type", "consult_complex", "work_type", "ARRA", 
               "datum", "lat_dec_deg", "long_dec_deg", "lat_deg", "lat_min", "lat_sec", 
               "long_deg", "long_min", "long_sec", "UTM_E", "UTM_N", "UTM_zone")

plc_tmp <- place
for (i in 1:length(fields)) {
    idf <- data.frame(x=names(get(fnames[[i]][1])),
                      y=as.vector(unlist(get(fnames[[i]][1]))))
    names(idf) <- c("activity_code", fnames[[i]][1])
    plc_tmp <- merge(plc_tmp, idf, by = "activity_code")
    print(fnames[[i]][1])
    print(dim(plc_tmp))
}

lede <- plc_tmp
lede <- merge(lede, spp_dat, by = "activity_code")
lede <- merge(lede, determ_counts)
names(lede)
names(lede)[36] <- "spp_BO_ls"

lede <- merge(lede, staff_hash_df, by = "activity_code")
lede <- merge(lede, stsup_hash_df, by = "activity_code")

tmp_lede <- lede
tmp_lede$spp_ev_ls <- unlist(lapply(tmp_lede$spp_ev_ls, FUN=paste, collapse="; "))
tmp_lede$spp_BO_ls <- unlist(lapply(tmp_lede$spp_BO_ls, FUN=paste, collapse="| "))
names(tmp_lede)

write.table(tmp_lede,
            file="data_prep/R/sec7_prep_v3/lede1.tsv",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)

############################################################################
# Fix up the var names, order, create missing vars; set data types
############################################################################
newd <- lede
names(newd)[43] <- "n_tech"
n_rpa <- newd$n_jeop
newd$date_active_concl <- newd$FWS_concl_date
newd <- cbind(newd[, c(1:14)], newd[, 46], newd[, 15:45])
names(newd)[15] <- "date_active_concl"
names(newd)[45] <- "staff_lead_hash"
names(newd)[46] <- "staff_support_hash"

work_type <- as.character(newd$work_type)
work_cat <- lapply(work_type, 
                   FUN = function(x) {tolower(strsplit(x, split = " - ")[[1]][1])})
head(unlist(work_cat), 20)

newd <- cbind(newd[, 1:22], 
              data.frame(work_category=unlist(work_cat)), 
              newd[, 23:46])

names(newd)[39] <- "n_spp_eval"

n_spp_BO_ls <- lapply(spp_BOdet, 
                      FUN = function(x) {
                          ifelse(x == " ",
                                 0,
                                 length(x))
                      })
nspls <- unlist(lapply(n_spp_BO_ls, FUN = unique))
nspdf <- data.frame(activity_code = names(nspls),
                    n_spp_BO = as.vector(nspls))
newd <- merge(newd, nspdf, by="activity_code")
names(newd)

n_conc <- rep(NA, length(newd$activity_code))
newd <- cbind(newd[, 1:39], newd[, 48], newd[, 44], newd[, 43], n_conc, 
              newd[, 40], n_rpa, newd[, 41], newd[, 45:47])
names(newd)

names(newd)[40:42] <- c("n_spp_BO", "n_nofx", "n_NLAA")
names(newd)[44] <- "n_jeop"
names(newd)[46] <- "n_admo"
names(newd)
new2 <- newd

new2$spp_ev_ls <- unlist(lapply(new2$spp_ev_ls, FUN=paste, collapse="; "))
new2$spp_BO_ls <- unlist(lapply(new2$spp_BO_ls, FUN=paste, collapse="| "))

write.table(new2,
            file="data_prep/R/sec7_prep_v3/prep_v1.tsv",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)

for (i in 1:length(newd)) {
    cat(paste0(i, " ", names(newd)[i], "\n"))
    cat(paste0("\t", class(newd[[i]]), "\n"))
    cat("==============\n")
}

to_char <- c(1, 4:6, 16:25, 36, 48, 49)
for(i in to_char) {
    newd[[i]] <- as.character(newd[[i]])
}

to_num <- c(2, 7:9, 14, 26:35)
for (i in to_num) {
    newd[[i]] <- as.numeric(as.character(newd[[i]]))
}

new3 <- newd
to_date <- c(10:13, 15)
for (i in to_date) {
    tmp <- as.numeric(as.character(new3[[i]]))
    t2 <- as.Date(tmp, origin="1899-12-30")
    new3[[i]] <- as.character(t2)
}

pre_names <- new3
pre_names$spp_ev_ls <- unlist(lapply(pre_names$spp_ev_ls, FUN=paste, collapse="; "))
pre_names$spp_BO_ls <- unlist(lapply(pre_names$spp_BO_ls, FUN=paste, collapse="| "))

write.table(pre_names,
            file="data_prep/R/sec7_prep_v3/pre_names.tsv",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)

##############################################################################
# Now for the horrifying task of homogenizing species names!
base5 <- "/Users/jacobmalcom/Repos/Defenders/section7_database/defenders_sec7_shiny"
infile <- paste0(base5, "/data/FWS_S7_clean_30Jul2015.RData")
load(infile)

ref_sp <- unlist(unlist(full$spp_ev_ls))
ref_uq <- unique(ref_sp)
length(ref_uq)

sp_ev <- unlist(unlist(new3$spp_ev_ls))
sp_ev_uq <- unique(sp_ev)
length(sp_ev_uq)

miss_sp_new <- setdiff(sp_ev_uq, ref_uq)
length(miss_sp_new)

# NOPE!  Going to have to use Python...





