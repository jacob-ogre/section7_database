# Templates for creating "large" tables for Shiny apps.
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
# Make the basic stats summary dataframe
#############################################################################
make_count_summary <- function(tmp, full) {
    tot_consults <- get_number_consults(full)
    tot_n_ESFO <- get_number_ESFO(full)
    tot_n_personnel <- get_number_personnel(full)
    tot_n_agencies <- get_number_agencies(full)
    
    All_data <- c(tot_consults, tot_n_ESFO, tot_n_personnel, tot_n_agencies)

    sub_n_consults <- get_number_consults(tmp())
    sub_n_ESFO <- get_number_ESFO(tmp())
    sub_n_personnel <- get_number_personnel(tmp())
    sub_n_agencies <- get_number_agencies(tmp())

    Select_data <- c(sub_n_consults, sub_n_ESFO, sub_n_personnel, sub_n_agencies)

    Proportion <- c(100*round(sub_n_consults / tot_consults, 2),
                    100*round(sub_n_ESFO / tot_n_ESFO, 2),
                    100*round(sub_n_personnel / tot_n_personnel, 2),
                    100*round(sub_n_agencies / tot_n_agencies, 2)
                    )

    variable <- c("# consultations", "# ES Offices", "# personnel", 
                  "# consulting agencies")
    stats_df <- data.frame(variable, All_data, Select_data, Proportion)
    names(stats_df) <- c("", "All data", "Selected data", 
                         "Percent (Select vs. All)")
    return(stats_df)
}

#############################################################################
# Make a summary df with time data
#############################################################################
make_time_species_summary <- function(tmp, full) {
    median_elapsed <- calculate_median_time(full)
    median_formal_elapsed <- calculate_median_formal_time(full)
    sub_median_elapsed <- calculate_median_time(tmp())
    sub_median_formal_elapsed <- calculate_median_formal_time(tmp())
    ratio_elapsed <- round_ratio(sub_median_elapsed, median_elapsed, 3)
    ratio_formal_elapsed <- round_ratio(sub_median_formal_elapsed, 
                                        median_formal_elapsed, 3)

    mean_n_spp_eval <- mean(full$n_spp_eval, na.rm=TRUE)
    mean_n_spp_BO <- mean(full$n_spp_BO, na.rm=TRUE)
    sub_mean_n_spp_eval <- mean(tmp()$n_spp_eval, na.rm=TRUE)
    sub_mean_n_spp_BO <- mean(tmp()$n_spp_BO, na.rm=TRUE)
    ratio_n_spp_eval <- round_ratio(sub_mean_n_spp_eval, mean_n_spp_eval, 3)
    ratio_n_spp_BO <- round_ratio(sub_mean_n_spp_BO, mean_n_spp_BO, 3)

    All_data <- c()
    Select_data <- c()
    Ratio_Select_to_All <- c()

    All_data <- c(round(median_elapsed, 1), 
                  round(median_formal_elapsed, 1),
                  round(mean_n_spp_eval, 1), 
                  round(mean_n_spp_BO, 1))
    Select_data <- c(round(sub_median_elapsed, 1), 
                     round(sub_median_formal_elapsed, 1),
                     round(sub_mean_n_spp_eval, 1), 
                     round(sub_mean_n_spp_BO, 1))
    Ratio_Select_to_All <- c(ratio_elapsed, ratio_formal_elapsed,
                             ratio_n_spp_eval, ratio_n_spp_BO)

    variable <- c("Duration (median days; Formal + Informal)", 
                  "Duration (median days; Formal)",
                  "# species evaluated (mean)", 
                  "# species in BO (mean)")
    res_df <- data.frame(variable, All_data, Select_data, Ratio_Select_to_All)
    names(res_df) <- c("", "All data", "Select data", "Percent (Select vs. All)")
    return(res_df)
}

#############################################################################
# Make a summary df with float values
#############################################################################
make_formal_consult_summary <- function(tmp, full) {
    tot_consults <- get_number_consults(full)
    tot_formal <- get_number_formal(full)

    det_concur <- sum(full$n_conc, na.rm=TRUE)
    tot_concur <- sum(full$n_conc[full$formal_consult=="Yes"] > 0, na.rm=TRUE)
    det_jeopardy <- sum(full$n_jeop, na.rm=TRUE)
    tot_jeopardy <- sum(full$n_jeop > 0, na.rm=TRUE)
    det_advmod <- sum(full$n_admo, na.rm=TRUE)
    tot_advmod <- sum(full$n_admo > 0, na.rm=TRUE)
    det_rpa <- sum(full$n_rpa, na.rm=TRUE)
    tot_rpa <- sum(full$n_rpa > 0, na.rm=TRUE)

    pct_formal <- round_ratio(tot_formal, tot_consults, 3)
    pct_concur <- round_ratio(tot_concur, tot_consults, 3)
    pct_jeopardy <- round_ratio(tot_jeopardy, tot_consults, 3)
    pct_advmod <- round_ratio(tot_advmod, tot_consults, 3)
    pct_rpa <- round_ratio(tot_rpa, tot_consults, 3)

    All_count <- c(tot_formal, tot_concur, tot_jeopardy, tot_advmod, tot_rpa)
    All_pct <- c(pct_formal, pct_concur, pct_jeopardy, pct_advmod, pct_rpa)
    All_det <- c(NA, det_concur, det_jeopardy, det_advmod, det_rpa)

    # Get the subset counts...
    sub_det_concur <- sum(tmp()$n_conc, na.rm=TRUE)
    sub_concur <- sum(tmp()$n_conc[tmp()$formal_consult=="Yes"] > 0, na.rm=TRUE)
    sub_det_jeopardy <- sum(tmp()$n_jeop, na.rm=TRUE)
    sub_jeopardy <- sum(tmp()$n_jeop > 0, na.rm=TRUE)
    sub_det_advmod <- sum(tmp()$n_admo, na.rm=TRUE)
    sub_advmod <- sum(tmp()$n_admo > 0, na.rm=TRUE)
    sub_det_rpa <- sum(tmp()$n_rpa, na.rm=TRUE)
    sub_rpa <- sum(tmp()$n_rpa > 0, na.rm=TRUE)

    sub_consults <- get_number_consults(tmp())
    sub_formal <- get_number_formal(tmp())

    # ...and calculate the percentages
    sub_pct_formal <- round_ratio(sub_formal, sub_consults, 3)
    sub_pct_concur <- round_ratio(sub_concur, sub_consults, 3)
    sub_pct_jeopardy <- round_ratio(sub_jeopardy, sub_consults, 3)
    sub_pct_advmod <- round_ratio(sub_advmod, sub_consults, 3)
    sub_pct_rpa <- round_ratio(sub_rpa, sub_consults, 3)
    
    Select_count <- c(sub_formal, sub_concur, sub_jeopardy, sub_advmod, sub_rpa)
    Select_pct <- c(sub_pct_formal, sub_pct_concur, sub_pct_jeopardy,
                    sub_pct_advmod, sub_pct_rpa)
    Select_det <- c(NA, sub_det_concur, sub_det_jeopardy, sub_det_advmod,
                    sub_det_rpa)

    Ratio_Select_to_All <- c(round_ratio(sub_formal, tot_formal, 3),
                             round_ratio(sub_concur, tot_concur, 3),
                             round_ratio(sub_jeopardy, tot_jeopardy, 3),
                             round_ratio(sub_advmod, tot_advmod, 3),
                             round_ratio(sub_rpa, tot_rpa, 3))

    variable <- c("Formal consultations", "Concurrence", "Jeopardy",
                  "Adverse Mod.", "Reas. Prud. Alternatives")

    res_df <- data.frame(variable, All_count, All_pct, Select_count,
                         Select_pct, Ratio_Select_to_All, All_det, Select_det)
    names(res_df) <- c("Outcome", "# consults (All)", "% of consults (All)",
                       "# consults (Select)", "% of consults (Select)", 
                       "% (# Select to All)", "# determ. (All)", 
                       "# determ. (Select)")
    return(res_df)
}


#############################################################################
# Make a summary df with lead_agency data
#############################################################################
make_agency_summary <- function(tmp, full) {
    all_table <- sort(table(full$lead_agency), decreasing=TRUE)
    sub_table <- sort(table(tmp()$lead_agency), decreasing=TRUE)
    All_names <- names(all_table)[1:10]
    All_count <- all_table[1:10]
    Sub_names <- names(sub_table)[1:10]
    Sub_count <- sub_table[1:10]
    res_df <- data.frame(All_names, All_count, Sub_names, Sub_count)
    row.names(res_df) <- NULL
    names(res_df) <- c("Agency (All data)", "# consult. (All)",
                       "Agency (Select data)", "# consult. (Select)")
    return(res_df)
}

#############################################################################
# Make a summary df with work category
#############################################################################
make_work_cat_summary <- function(tmp, full) {
    all_table <- sort(table(full$work_category), decreasing=TRUE)
    sub_table <- sort(table(tmp()$work_category), decreasing=TRUE)
    All_names <- names(all_table)[1:10]
    All_count <- all_table[1:10]
    Sub_names <- names(sub_table)[1:10]
    Sub_count <- sub_table[1:10]
    res_df <- data.frame(All_names, All_count, Sub_names, Sub_count)
    row.names(res_df) <- NULL
    names(res_df) <- c("Work category (All data)", "# consult. (All)",
                       "Work category (Select data)", "# consult. (Select)")
    return(res_df)
}

#############################################################################
# Make a summary df with species
#############################################################################
make_species_summary <- function(tmp, full) {
    all_table <- sort(table(unlist(full$spp_ev_ls)), decreasing=TRUE)
    sub_table <- sort(table(unlist(tmp()$spp_ev_ls)), decreasing=TRUE)
    All_names <- names(all_table)[1:10]
    All_count <- all_table[1:10]
    Sub_names <- names(sub_table)[1:10]
    Sub_count <- sub_table[1:10]
    res_df <- data.frame(All_names, All_count, Sub_names, Sub_count)
    row.names(res_df) <- NULL
    names(res_df) <- c("Species (All data)", "# consult. (All)",
                       "Species (Select data)", "# consult. (Select)")
    return(res_df)
}


