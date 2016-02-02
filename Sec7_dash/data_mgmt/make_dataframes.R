# Functions to create dataframes, typically for plot generation.
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
#############################################################################
# Dataframes for State/Species pages
#############################################################################
#############################################################################

############################################################################
# Create a small dataframe for front-page summary figure
make_consult_year_summary_df <- function(x) {
    cons_yr <- calculate_consults_per_year(x)
    form_yr <- calculate_formal_per_year(x)
    years <- names(cons_yr)
    dat <- data.frame(years, as.vector(cons_yr), as.vector(form_yr))
    names(dat) <- c("years", "cons_yr", "form_yr")
    return(dat)
}

############################################################################
# Create a small dataframe for state species summary figure
make_state_species_df <- function(x) {
    cur_species <- table(unlist(x$spp_ev_ls))
    sorted <- -sort(-cur_species)
    dat <- data.frame(names(sorted), sorted)
    names(dat) <- c("species", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for species-ESO summary figure
make_species_by_ESO_df <- function(x) {
    cur_offices <- table(x$ESOffice)
    sorted <- -sort(-cur_offices)
    dat <- data.frame(names(sorted), sorted)
    names(dat) <- c("offices", "consultations")
    dat <- dat[dat$consultations > 0,]
    return(dat)
}

############################################################################
# Create a small dataframe for state agencies summary figure
make_state_agencies_df <- function(x) {
    cur_species <- table(droplevels(x$lead_agency))
    sorted <- -sort(-cur_species)
    dat <- data.frame(names(sorted), sorted)
    names(dat) <- c("agency", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for state work categories summary figure
make_state_work_cat_df <- function(x) {
    categories <- table(droplevels(x$work_category))
    sorted <- -sort(-categories)
    dat <- data.frame(names(sorted), sorted)
    names(dat) <- c("work_cat", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for state work categories summary figure
make_state_cons_complex_df <- function(x) {
    complexities <- table(droplevels(x$consult_complex))
    sorted <- -sort(-complexities)
    dat <- data.frame(names(sorted), sorted)
    names(dat) <- c("complexity", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for state formal consult summary figure
make_state_formal_df <- function(x) {
    formal <- table(droplevels(x$formal_consult))
    sorted <- -sort(-formal)
    dat <- data.frame(names(sorted), sorted)
    names(dat) <- c("formal", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for consults by region plot
make_by_region_df <- function(x) {
    all_res <- table(x$region)
    formals <- table(x[x$formal_consult=="Yes", ]$region)
    dat <- data.frame(as.character(names(all_res)), as.vector(all_res), as.vector(formals))
    names(dat) <- c("region", "all_consult", "formal_consult")
    return(dat)
}

############################################################################
# Create a small dataframe for consults by FY plot
make_by_fy_df <- function(x) {
    all_res <- table(x$FY)
    formals <- table(x[x$formal_consult=="Yes", ]$FY)
    year_dat <- paste("FY", as.character(names(all_res)))
    dat <- data.frame(year_dat, as.vector(all_res), as.vector(formals))
    names(dat) <- c("year", "all_consult", "formal_consult")
    return(dat)
}

############################################################################
# Create a small dataframe for consults by personnel by region plot
make_consult_region_personnel_df <- function(x) {
    cons_cnt <- count_per_level(x$activity_code, x$region)
    pers_cnt <- count_per_level(x$staff_lead_hash, x$region)
    reg_names <- paste(rep("Region", length(cons_cnt)), names(cons_cnt))
    dat <- data.frame(reg_names, cons_cnt, pers_cnt)
    names(dat) <- c("region", "cons_cnt", "pers_cnt")
    return(dat)
}

############################################################################
# Create a small dataframe for consults by personnel by region plot
make_consult_year_personnel_df <- function(x) {
    cons_cnt <- count_per_level(x$activity_code, x$FY)
    pers_cnt <- count_per_level(x$staff_lead_hash, x$FY)
    reg_names <- paste(rep("FY", length(cons_cnt)), names(cons_cnt))
    dat <- data.frame(reg_names, cons_cnt, pers_cnt)
    names(dat) <- c("year", "cons_cnt", "pers_cnt")
    return(dat)
}

############################################################################
# Create a small dataframe for top 100 species bar plot
make_top_100_species_df <- function(sub) {
    sub_species <- table(unlist(sub$spp_ev_ls))
    sorted <- -sort(-sub_species)
    dat <- data.frame(names(sorted)[1:100], sorted[1:100])
    names(dat) <- c("species", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for top 100 agencies bar plot
make_top_100_agencies_df <- function(sub) {
    sub_agency <- table(droplevels(sub$lead_agency))
    sorted <- -sort(-sub_agency)
    dat <- data.frame(names(sorted)[1:100], sorted[1:100])
    names(dat) <- c("agencies", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for top 100 work_cat bar plot
make_top_100_work_cat_df <- function(sub) {
    sub_work_cat <- table(droplevels(sub$work_category))
    sorted <- -sort(-sub_work_cat)
    dat <- data.frame(names(sorted)[1:100], sorted[1:100])
    names(dat) <- c("work_cat", "consultations")
    return(dat)
}

############################################################################
# Create a small dataframe for mapping
make_map_df <- function(sub, esls) {
    cur_tab <- table(sub$ESOffice)
    to_remove <- setdiff(names(cur_tab), esls)
    tab_upd <- cur_tab[!(names(cur_tab) %in% to_remove)]
    # print(head(tab_upd))
    return(tab_upd)
}
