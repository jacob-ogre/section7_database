# Templates for creating "small" tables for Shiny apps.
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

#############################################################################
# Templates for creating "small" tables for Shiny apps.
#
# Unlike large tables, which are often one-off designs, making "small" tables 
# seems amenable to making generic functions to generate the 
# The "templates" here should be useful for tasks such as small tables that 
# accompany a figure.
#
#############################################################################

#############################################################################
#############################################################################
#############################################################################
#############################################################################
#############################################################################
# #############################################################################
# # Generic form of a simple two-column table
# simple_two_column_table <- function(sub, full) {

#     # collect values for col 2
#     v1 <- sum()
#     v2 <- sum()
#     col2 <- c(v1, v2, ...)

#     # variable strings with length == length(col2)
#     variables <- c("var1", "var2", ...)

#     res_df <- data.frame(variables, data_col)

#     # keep the col names empty for cleanliness
#     names(res_df) <- c("", "")
#     return(res_df)
# }

# #############################################################################
# # Generic form of a dynamic two-column table
# dynamic_two_column_table <- function(sub, full) {

#     # Check if a variable selection has been made, if not, show an empty table
#     if (length(levels(droplevels(as.factor(sub$<var>)))) > 1) {
#         dat <- c("", "Please select <var> for summary table", "")
#         var <- c("", "", "")
#         noData <- data.frame(var, dat)
#         names(noData) <- ""
#         return(noData)
#     }

#     # collect values for col 2
#     v1 <- sum()
#     v2 <- sum()
#     col2 <- c(v1, v2, ...)

#     # variable strings with length == length(col2)
#     variables <- c("var1", "var2", ...)

#     res_df <- data.frame(variables, data_col)

#     # keep the col names empty for cleanliness
#     names(res_df) <- c("", "")
#     return(res_df)
# }

# #############################################################################
# # Generic form of a subset-all-pct summary statistics dataframe
# sub_all_pct_table <- function(sub, full, ...) {

#     # organize by tot and sub to make the vectors for the result df
#     tot_n <- length(levels(droplevels(full$<var>)))
#     tot_m <- sum(full$<var>, na.rm=TRUE)
#     tot_val <- c(tot_n, tot_m)

#     sub_n <- length(levels(droplevels(sub$<var>)))
#     sub_m <- sum(sub$<var>, na.rm=TRUE)
#     sub_val <- c(sub_n, sub_m)

#     pct_n <- round((sub_n / tot_n) * 100, 2)
#     pct_m <- round((sub_m / tot_m) * 100, 2)
#     pcts <- c(prop_n, prop_m)

#     variables <- c("n", "m")
#     res_df <- data.frame(variables, sub_val, tot_val, pcts)
#     names(res_df) <- c("", "Selected", "All", "Pct (select/all)")
#     return res_df
# }

# #############################################################################
# # Generic form of a table with sorted results (top 10 here)
# make_work_cat_summary <- function(sub, full) {
#     all_table <- sort(table(full$<var>), decreasing=TRUE)
#     sub_table <- sort(table(sub$<var>), decreasing=TRUE)
#     all_names <- names(all_table)[1:10]
#     all_count <- all_table[1:10]
#     sub_names <- names(sub_table)[1:10]
#     sub_count <- sub_table[1:10]
#     res_df <- data.frame(All_names, All_count, Sub_names, Sub_count)
#     row.names(res_df) <- NULL
#     names(res_df) <- c("<var> (All data)", "# <records> (All)",
#                        "<var> (Select data)", "# <records> (Select)")
#     return(res_df)
# }


