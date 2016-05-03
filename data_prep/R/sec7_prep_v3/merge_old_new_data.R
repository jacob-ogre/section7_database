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

library(ggplot2)
library(ggthemes)
library(scales)

############################################################################
# load the data sets
load("FWS_S7_clean_30Jul2015.RData")

new <- read.csv("Apr2016_data_cleaned.tsv",
                sep = "\t",
                header = TRUE,
                stringsAsFactors = FALSE)

############################################################################
# now let's start looking at them
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

tmp_ev_str <- gsub(pattern = "|", 
                   replacement = " ",  
                   x = new$spp_ev_ls, 
                   fixed = TRUE)
tmp_ev_ls <- strsplit(x = tmp_ev_str, split = "...", fixed = TRUE)
length(tmp_ev_ls)
new$spp_ev_ls <- tmp_ev_ls

dim(full)
dim(new)

dups <- intersect(full$activity_code, new$activity_code)
length(dups)

upd_new <- new[!new$activity_code %in% dups, ]
dim(upd_new)

fin <- rbind(full, upd_new)
dim(fin)

# for consistency with the app, now rename fin -> full
full <- fin
save(full, file = "FWS_S7_clean_02May2016.RData")


############################################################################
# re-load the new data to deal with bad data points
load("FWS_S7_clean_02May2016.RData")
save(full, file = "FWS_S7_clean_02May2016_bak.RData")

neg <- full[full$elapsed < 0 & !is.na(full$elapsed), ]

pre <- full[full$FY < 2008 & !is.na(full$FY), ]
head(pre[, 1:15])

######## A couple of date issues...
# First, there are eight formal consultations where the start of formal
# consultation is after FWS_concl, but I think FWS_concl is for informal
# stage. These highlight the need to link formal and informal, but to have
# separate records for each type.
full$elapsed <- ifelse(full$elapsed < 0, NA, full$elapsed)

# Next, the new data includes 61 consultations with FY < 2008. It looks like 
# people are entering FY and FY_start rather haphazardly, with some entries
# logging the current consult FY in FY_start, but that also has the original
# consult FY in some cases (>500).

# I don't see in my previous cleaning code where I would have set such entries 
# to NA, # so (unfortunately) I probably did that from the console. Have decided 
# to set # those entries to NA, at least for now.
full$FY <- ifelse(full$FY < 2008, NA, full$FY)

# It might be useful to have dates as class Date...but I will hold off for now

####### Agency corrections
# presumably the table is still valid...
changes <- read.table("lead_agency_rev_data.tsv",
                      sep="\t",
                      header=T,
                      stringsAsFactors=F)
names(changes) <- c("idx", "agency", "paren", "fix", "comment")
head(changes)

add_paren <- function(x) {
    if(is.na(x) | x == "") { return(x) }
    cur_agency <- changes[changes$agency == x & changes$agency != "" & !is.na(changes$idx), ]
    if(as.logical(length(.subset2(cur_agency, 1L)))) {
        if(nrow(cur_agency) == 1 & cur_agency$paren != "" & !is.na(cur_agency[1,1])) {
            return(paste0(cur_agency$agency, " (", cur_agency$paren, ")"))
        } else {
            return(x)
        }
    } else {
        return(x)
    }
}
test_fix <- unlist(lapply(full$lead_agency, FUN = add_paren))

full$lead_agency <- test_fix

full$lead_agency <- ifelse(full$lead_agency=="Forest Service" &
                           full$ESOffice=="NEW JERSEY ECOLOGICAL SERVICES FIELD OFFICE",
                           "NJ Forest Service",
                           as.character(full$lead_agency))
full$lead_agency <- as.factor(full$lead_agency)

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


save(full, file = "FWS_S7_clean_03May2016_0-1.RData")

###########################################################################
# Tests
names(full)
table(full$region)
table(full$state)
table(full$ESOffice)
table(full$FY)

# want to plot the dates...but NOTE that X is left-trimmed
tmp <- full
tmp$st_date <- as.Date(tmp$start_date)
tmp$st_num <- as.numeric(tmp$st_date)

p <- ggplot(tmp, aes(st_date, ..count..)) +
     geom_histogram(binwidth = 90, colour="white") +
     scale_x_date(date_breaks = "1 year",
                  date_labels = "%Y",
                  limits = c(as.Date("2007-01-01"),
                             as.Date("2016-06-30"))) +
     labs(x = "Year",
          y = "# consultations\n") +
     theme_pander() +
     theme(axis.text.x = element_text(angle = 45, hjust = 1))
p

length(full$elapsed[full$elapsed < 0 & !is.na(full$elapsed)])
head(sort(table(full$work_category), decreasing=TRUE), 20)
table(full$datum)

save(full, file = "FWS_S7_clean_03May2016_0-2.RData")
# now jumping out to 'convert_coords.R' to make everything NAD83 dec. deg.

# fix FL panther
q <- full



