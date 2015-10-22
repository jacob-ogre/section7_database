# Combine the 2008-2014 data with 2014-Apr2015 data.
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

require(digest)

base <- "~/OneDrive/Defenders/data/ESA_consultations/TABs"
old_fil <- paste(base, "FWS_consults_08-14_updNames_byConsult.tab", sep="/")
new_fil <- paste(base, "FWS_consults_14-15_updNames_byConsult.tab", sep="/")

old <- read.table(old_fil, sep="\t", header=TRUE, stringsAsFactors=FALSE)
new <- read.table(new_fil, sep="\t", header=TRUE, stringsAsFactors=FALSE)

names(old) == names(new)
names(old)

overlap <- intersect(old$activity_code, new$activity_code)

old_shr <- old[old$activity_code %in% overlap, ]
new_shr <- new[new$activity_code %in% overlap, ]

dim(old_shr)
dim(new_shr)

shared <- rbind(old_shr, new_shr)
dim(shared)
sorted <- shared[order(shared$activity_code), ]

pre14ac <- setdiff(old$activity_code, new$activity_code)
base_set <- old[old$activity_code %in% pre14ac, ]

data_08_15 <- rbind(base_set, new)
dim(data_08_15)

#############################################################################
#############################################################################
# Hash the staff names
#############################################################################
#############################################################################
data_08_15$staff_lead_hash <- rep("", length(data_08_15$staff_lead))
for (i in 1:length(data_08_15$staff_lead_hash)) {                       
    if (as.character(data_08_15$staff_lead[i]) != "") {
        data_08_15$staff_lead_hash[i] <- digest(data_08_15$staff_lead[i], "md5")
    } else {
        data_08_15$staff_lead_hash[i] <- "None"
    }
}

for (i in 1:length(to_hash$staff_lead_hash)) {                       
    if (as.character(to_hash$staff_lead[i]) != "") {
        to_hash$staff_lead_hash[i] <- digest(to_hash$staff_lead[i], "md5")
    } else {
        to_hash$staff_lead_hash[i] <- "None"
    }
}

data_08_15$staff_support_hash <- rep("", length(data_08_15$staff_support))
for (i in 1:length(data_08_15$staff_support_hash)) {                       
    if (as.character(data_08_15$staff_support[i]) != "") {
        data_08_15$staff_support_hash[i] <- digest(data_08_15$staff_support[i], "md5")
    } else {
        data_08_15$staff_support_hash[i] <- "None"
    }
}

for (i in 1:length(to_hash$staff_support_hash)) {                       
    if (as.character(to_hash$staff_support[i]) != "") {
        to_hash$staff_support_hash[i] <- digest(to_hash$staff_support[i], "md5")
    } else {
        to_hash$staff_support_hash[i] <- "None"
    }
}

data_08_15$staff_lead_hash <- as.factor(data_08_15$staff_lead_hash)
data_08_15$staff_support_hash <- as.factor(data_08_15$staff_support_hash)

data_08_15 <- data_08_15[,-12]
data_08_15 <- data_08_15[,-8]

# fix the dates issue for the jQuery table representation
data_08_15$start_date <- as.character(data_08_15$start_date)
data_08_15$due_date <- as.character(data_08_15$due_date)
data_08_15$FWS_concl_date <- as.character(data_08_15$FWS_concl_date)
data_08_15$date_active_concl <- as.character(data_08_15$date_active_concl)
data_08_15$date_formal_consult <- as.character(data_08_15$date_formal_consult)

filtout <- "~/OneDrive/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-15_final_byConsult.RData"
save(data_08_15, file=filtout)
# load(filtout)

staff_hash <- data.frame(data_08_15$staff_lead, data_08_15$staff_lead_hash,
                         data_08_15$staff_support, data_08_15$staff_support_hash)
name_hash_out <- "~/OneDrive/Defenders/data/ESA_consultations/TABs/Sec7_08-15_staff_md5.tab"
write.table(staff_hash, file=name_hash_out, quote=FALSE, row.names=FALSE, sep="\t")

#############################################################################
#############################################################################

# Check some stats:
jeop <- data_08_15[data_08_15$n_jeop > 0 & !is.na(data_08_15$n_jeop), ]
admo <- data_08_15[data_08_15$n_admo > 0 & !is.na(data_08_15$n_admo), ]
dim(jeop)
dim(admo)
# OK, these look pretty good!


# Write the file as tab, then type conversion, the .RData...
outf <- "~/OneDrive/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-Apr15.tab"
write.table(data_08_15, 
            outf, 
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

##########################################################################
# Some extras on re-hashing...
names(to_hash) <- c("activity_code", "upd_staff_lead", "upd_staff_support",
                    "upd_staff_lead_hash", "upd_staff_support_hash")

new_full <- merge(full, to_hash, by="activity_code")
names(new_full)
new_full <- new_full[, -c(48, 47)]

full <- new_full
save(full, file="data/FWS_S7_clean_13Jul2015_withNames.RData")

full <- full[,-c(50, 51)]
save(full, file="data/FWS_S7_clean_13Jul2015.RData")


#########################



