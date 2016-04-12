# Add 2015 - early 2016 section 7 data.
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

library(readxl)

##########################################################################
# Load the data
##########################################################################

base <- "/Users/jacobmalcom/Dropbox/TAILS data/"

##########
# First I need to deal with the "extras"...unfortunately, the first two extra
# Excels have fewer columns than all of the others, so I will catenate the 
# 'normal' files and then manually (i.e., in Excel) add the smaller files in
excels <- list.files(paste0(base, "/extras_March2016"))
dfs <- c()
for (i in 3:length(excels)) {
    cur_dat <- read_excel(paste0(base, "/extras_March2016/", excels[i]),
                          col_types = rep("text", 49))
    assign(paste0("part_", i), cur_dat)
    dfs <- c(dfs, paste0("part_", i))
    print(c(paste0("part_", i), dim(cur_dat)))
}

extras <- part_3
for (i in 1:length(dfs)) {
    extras <- rbind(extras, get(dfs[i]))
}
print(dim(extras))

##########
# Now get all of the regular files.
#
# Except no. The first file (April 2015) has 54 cols while all other files have
# 49 cols. No idea why at the moment, but there's extra information there. As
# above, will have to do some manual edits before even getting to the starting
# dataframe.
excels <- list.files(base)
dfs <- c()
for (i in 5:length(excels)) {
    if (substr(excels[i], 1, 5) == "TAILS") {
        j <- excels[i]
        part1 <- strsplit(j, ".", fixed = TRUE)
        k <- part1[[1]][1]
        part2 <- strsplit(k, "_", fixed = TRUE)
        l <- gsub(" ", "_", paste(part2[[1]][3], part2[[1]][4], sep="_"))
        cur_dat <- read_excel(paste0(base, "/", j), 
                              col_types = rep("text", 49))
        print(c(l, dim(cur_dat)))
        assign(l, cur_dat)
        dfs <- c(dfs, l)
    }
}

new_dat <- Formal_August_2015
for (i in 2:length(dfs)) {
    new_dat <- rbind(new_dat, get(dfs[i]))
}
    
new_dat <- rbind(new_dat, extras)

# write.table(new_dat, 
#             file = paste0(base, "/extracted/new_data_part_1.tsv"),
#             quote = FALSE,
#             sep = "\t",
#             row.names = FALSE)

#######################################
# OK, I'm going to attempt to automate the data fixes.
Form_Apr_15 <- read_excel(paste0(base, "/TAILS_Report_Formal_April 2015.xlsx"),
                          col_types = rep("text", 54))
setdiff(names(Form_Apr_15), names(new_dat))

Form_Apr_15 <- Form_Apr_15[, c(1:37, 43:54)]
dim(Form_Apr_15)

new_dat <- rbind(new_dat, Form_Apr_15)

# now for the extras...
ex1 <- read_excel(paste0(base, "/extras_March2016/HD-12087-July_7_R4_Informal.xlsx"),
                  col_types = rep("text", 34))
missing <- setdiff(names(new_dat), names(ex1))

lede <- ex1[, c(1:13)]
lenex1 <- length(ex1[[1]])
NAs <- rep(NA, lenex1)

for (i in missing) {
    assign(i, NAs)
}

miss_dat <- data.frame(`Species Involved / Evaluated`,
                       `Supporting Staff`,
                       `Supporting Agencies`,
                       `Datum`,
                       `Latitude`,
                       `Longitude`,
                       `Lat Degrees`,
                       `Lat Minutes`,
                       `Lat Seconds`,
                       `Long Degrees`,
                       `Long Minutes`,
                       `Long Seconds`,
                       `UTM East`,
                       `UTM North`,
                       `UTM Zone`)

ex1_upd <- cbind(ex1[, c(1:13)], miss_dat, ex1[, c(14:34)])
names(ex1_upd) <- names(new_dat)

setdiff(names(new_dat), names(ex1_upd))

new_dat <- rbind(new_dat, ex1_upd)

# Now for the other extra
ex2 <- read_excel(paste0(base, "/extras_March2016/HD-12087-May_15_R1_Formal.xlsx"),
                  col_types = rep("text", 28))
missing <- setdiff(names(new_dat), names(ex2))

lenex2 <- length(ex2[[1]])
NAs <- rep(NA, lenex2)

for (i in missing) {
    assign(i, NAs)
}

miss_dat <- data.frame(`Start Date Fiscal Year`,
                       `Conclusion Date FY`,
                       `Active/Concluded`,
                       `Concluded in Timely Manner`,
                       `Elapsed Days`,
                       `Days Till Due`,
                       `Staff Hours Logged Current FY`,
                       `Events Logged Current FY`,
                       `No further Service work performed`,
                       `Formal`,
                       `Consultation Type`,
                       `Consultation Complexity`,
                       `Formal Consultation Initiated Date`,
                       `Withdrawn`,
                       `Biological Opinion Species`,
                       `Biological Conclusion Determination`,
                       `Critical Habitat Biological Conclusion Determination`,
                       `Critical Habitat Flag`,
                       `Take`,
                       `Action/Work Type`,
                       `Performance Reporting Category mapped from Action/Work Type`)

ex2_upd <- cbind(ex2[, c(1:13)], ex2[, c(26:28)], ex2[, c(14:25)], miss_dat)
names(ex2_upd) <- names(new_dat)

new_dat <- rbind(new_dat, ex2_upd)
dim(new_dat)

write.table(new_dat, 
            file = paste0(base, "/extracted/new_data_raw.tsv"),
            quote = FALSE,
            sep = "\t",
            row.names = FALSE)

# NOTE:
# Just getting the data out was a real pain, if for no other reason than because
# of inconsistencies in the variables that were downloaded varied between 
# Excel files. There *HAS* to be a better way...









