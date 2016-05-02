# Concatenate the old and new section 7 datasets.
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

############################################################################
# load the data sets
load("FWS_S7_clean_30Jul2015.RData")

new <- read.csv("Apr2016_data_cleaned.tsv",
                sep = "\t",
                header = TRUE,
                stringsAsFactors = FALSE)

names(full)
names(new)
names(full) == names(new)

get_classes <- function(x, y) {
    for(i in 1:length(x)) {
        if(class(x[[i]]) != class(y[[i]])) {
            print(names(x)[i])
            cat(paste0("\t", class(x[[i]]), "\t", class(y[[i]]), "\n"))
        }
    }
}
get_classes(full, new)


