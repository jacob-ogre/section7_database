# Use lookup to tally consultations by taxonomic group.
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

################################################################################
# Consultation data is loaded using shiny::runApp()
################################################################################

################################################################################
# Load reference table and manage the consultation data
################################################################################
lookf <- "/Users/jacobmalcom/OneDrive/Defenders/data/ESA_consultations/reference_tabs/species_to_groups.tab"
lookup <- read.table(lookf, sep="\t", header=FALSE)
names(lookup) <- c("group", "common_name", "common_group", "common_specific",
                   "scientific", "genus", "species")
lookup$combo <- paste(lookup$common_name, " (", lookup$scientific, ")", sep="")
lookup$combo <- gsub("  ", " ", lookup$combo, fixed=TRUE)

unlisted <- data.frame(combo=as.character(unlist(full$spp_ev_ls)))
unlisted$combo <- gsub("  ", " ", unlisted$combo, fixed=TRUE) 
test <- merge(lookup, unlisted, by="combo")
group_counts_1 <- sort(table(test$group), decreasing=TRUE)

not_in_lookup <- setdiff(unlisted$combo, lookup$combo)
missing <- as.character(unlisted$combo[unlisted$combo %in% not_in_lookup])
tab_missing <- sort(table(missing), decreasing=TRUE)
miss_uniq <- as.character(levels(as.factor(missing)))

################################################################################
# Define a couple of functions
################################################################################
get_two_parts <- function(x) {
    lens <- sapply(x, FUN=length)
    twop <- x[lens == 2]
    idxs <- lens == 2
    first <- unlist(twop)[2*(1:length(twop)) - 1]
    second <- unlist(twop)[2*(1:length(twop))]
    return(list(first, second, idxs))
}

get_three_parts <- function(x) {
    lens <- sapply(x, FUN=length)
    idx1 <- lens == 1
    idx3 <- lens == 3
    idx4 <- lens == 4
    trip <- x[idx3]
    quad <- x[idx4]
    singleton <- x[idx1]
    first <- unlist(trip)[3*(1:length(trip)) - 2]
    second <- unlist(trip)[3*(1:length(trip)) - 1]
    third <- unlist(trip)[3*(1:length(trip))]
    first.a <- unlist(quad)[4*(1:length(quad)) - 3]
    second.a <- unlist(quad)[4*(1:length(quad)) - 2]
    third.a <- unlist(quad)[4*(1:length(quad))]
    first <- c(first, first.a, "")
    second <- c(second, second.a, "")
    third <- c(third, third.a, "")
    return(list(first, second, third, idx1, idx3, idx4))
}

miss_parts <- strsplit(miss_uniq, " (", fixed=TRUE)
first_split <- get_two_parts(miss_parts)
miss_comm <- first_split[[1]]
miss_sci <- first_split[[2]]

basic_df <- data.frame(group=rep("", length(miss_comm)),
                       missing_common=miss_comm, 
                       miss_comm_group=rep("", length(miss_comm)),
                       miss_comm_specific=rep("", length(miss_comm)),
                       miss_scientific=miss_sci,
                       miss_genus=rep("", length(miss_comm)),
                       miss_species=rep("", length(miss_comm)))

outf <- "/Users/jacobmalcom/OneDrive/Defenders/data/ESA_consultations/reference_tabs/species_to_groups_missing.tab"
write.table(basic_df,
            outf,
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

newinf <- "/Users/jacobmalcom/OneDrive/Defenders/data/ESA_consultations/reference_tabs/species_to_groups_missing_filled.tab"
new_names <- read.table(newinf, header=TRUE, sep="\t")
names(new_names) <- c("group", "common_name", "common_group", "common_specific",
                     "scientific", "genus", "species")

new_names$combo <- paste(new_names$common_name, " (", new_names$scientific, ")", sep="")
new_names$combo <- gsub("  ", " ", new_names$combo, fixed=TRUE)
full_ref <- rbind(lookup, new_names)

unlisted <- data.frame(combo=as.character(unlist(full$spp_ev_ls)))
unlisted$combo <- gsub("  ", " ", unlisted$combo, fixed=TRUE) 
semi_final <- merge(full_ref, unlisted, by="combo")
group_counts_1 <- table(semi_final$group)
group_pcts <- group_counts_1 / sum(group_counts_1)

group_counts_1

ref_group_counts <- table(full_ref$group)
ref_group_pcts <- ref_group_counts / sum(ref_group_counts)


pct_consults <- group_pcts*100
pct_listings <- ref_group_pcts*100

pct_consults <- round(group_pcts, 3)*100
pct_listings <- round(ref_group_pcts, 3)*100

round(pct_consults / pct_listings, 3) * 100



