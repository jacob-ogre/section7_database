# Functions to summarize data for a Shiny App.
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

############################################################################
# Helper functions for factors
fac2num <- function(x) {
    return(as.numeric(as.character(x)))
}

fac2char <- function(x) {
    return(as.character(x))
}

############################################################################
# General helper functions
round_ratio <- function(x, y, places=3) {
    round(x / y, places) * 100
}

count_per_level <- function(x, y) {
    z <- tapply(x,
                INDEX=y,
                FUN=function(g) {length(levels(droplevels(as.factor(g))))}
                )
    return(z)
}

############################################################################
# Helper functions for years
get_number_years <- function(x) {
    return(length(levels(droplevels(x$FY))))
}

get_min_year <- function(x) {
    return(min(fac2num(x$FY), na.rm=T))
}

get_max_year <- function(x) {
    return(max(fac2num(x$FY), na.rm=T))
}

get_year_range <- function(x) {
    min_yr <- get_min_year(x)
    max_yr <- get_max_year(x)
    if (min_yr != max_yr) {
        return(paste(min_yr, "-", max_yr))
    } else {
        return(min_yr)
    }
}

############################################################################
# Helper functions for consultations
get_number_consults <- function(x) {
    return(length(x$activity_code))
}

get_number_formal <- function(x) {
    return(sum(x$formal_consult=="Yes", na.rm=T))
}

calculate_consults_per_year <- function(x) {
    return(table(x$FY))
}

calculate_formal_per_year <- function(x) {
    return(table(x[x$formal_consult=="Yes",]$FY))
}

calculate_n_jeop_cons <- function(x) {
    return(sum(x$n_jeop > 0, na.rm=T))
}

calculate_n_admod_cons <- function(x) {
    return(sum(x$n_admo > 0, na.rm=T))
}

############################################################################
# Helper functions for species
get_number_species <- function() {
    return(length(species)-1)
}

get_number_groups <- function(x) {
    return(length(levels(droplevels(x$Group))))
}

calculate_state_n_spp <- function(x) {
    cur_sp_ls <- levels(as.factor(unlist(x$spp_ev_ls)))
    return(length(cur_sp_ls))
}

############################################################################
# Helper functions for agencies
get_number_agencies <- function(x) {
    return(length(levels(droplevels(x$lead_agency))))
}

############################################################################
# Helper functions for personnel
get_number_personnel <- function(x) {
    return(length(levels(droplevels(x$staff_lead_hash))))
}

############################################################################
# Helper functions for ESFOs
get_number_ESFO <- function(x) {
    return(length(levels(droplevels(x$ESOffice))))
}

############################################################################
# Helper functions for consultation time
calculate_median_time <- function(x) {
    return(median(x$elapsed, na.rm=TRUE))
}

calculate_median_formal_time <- function(x) {
    return(median(x[x$formal_consult=="Yes",]$elapsed, na.rm=TRUE))
}

############################################################################
# Helper functions for states data/summaries
get_cur_state <- function(x) {
    if (x == "All") {
        return("Please select a state from dropdown")
    } else {
        return(x)
    }
}

get_number_states <- function(x) {
    return(length(levels(droplevels(x$State))))
}

calculate_n_sp_per_state <- function(x) {
    res <- tapply(x$Scientific,
                  INDEX=x$State,
                  FUN=get_number_species)
    return(res)
}

calculate_spend_per_state <- function(x) {
    res <- tapply(x$Grand_Total,
                  INDEX=x$State,
                  FUN=sum, na.rm=TRUE)
    return(res)
}

calculate_state_total_exp <- function(x) {
    return(sum(x$Grand_Total, na.rm=TRUE))
}

calculate_state_general_exp <- function(x) {
    return(sum(x$General_Expenditures, na.rm=TRUE))
}

calculate_state_land_exp <- function(x) {
    return(sum(x$Land_Expenditures, na.rm=TRUE))
}

calculate_state_raw_rank <- function(all, cur_state) {
    if (cur_state == "All") {
        return("-")
    }
    state_spend <- calculate_spend_per_state(all)
    state_ranks <- rank(-state_spend)
    res <- state_ranks[cur_state][[1]]
    return(res)
}

calculate_state_per_sp_rank <- function(all, cur_state) {
    if (cur_state == "All") {
        return("-")
    }
    state_n_spp <- calculate_n_sp_per_state(all)
    state_spend <- calculate_spend_per_state(all)
    per_spp_spend <- state_spend / state_n_spp
    state_ranks <- rank(-per_spp_spend)
    res <- state_ranks[cur_state][[1]]
    return(res)
}

calculate_cur_state_tot_exp <- function(x, cur_state) {
    if (cur_state == "All") {
        return("-")
    }
    expend <- calculate_state_total_exp(x())
    return(make_dollars(expend))
}

calculate_cur_state_land_exp <- function(x, cur_state) {
    if (cur_state == "All") {
        return("-")
    }
    expend <- calculate_state_land_exp(x)
    return(make_dollars(expend))
}

calculate_cur_state_gen_exp <- function(x, cur_state) {
    if (cur_state == "All") {
        return("-")
    }
    expend <- calculate_state_general_exp(x)
    return(make_dollars(expend))
}

calculate_cur_state_mult_exp <- function(x, cur_state) {
    if (cur_state == "All") {
        return("-")
    }
    cur_sub <- x[x$Group == "Multi-species",]   
    return(make_dollars(calculate_state_total_exp(cur_sub)))
}

############################################################################
# Helper functions for fed data/summaries
calculate_cur_state_fed_exp <- function(fed, state, cur_state) {
    if (cur_state == "All") {
        return("-")
    }
    min_st_yr <- min(fac2num(state$FY), na.rm=TRUE)
    max_st_yr <- max(fac2num(state$FY), na.rm=TRUE)
    fed_comp <- fed[fac2num(fed$FY) <= max_st_yr &
                    fac2num(fed$FY) >= min_st_yr,]
    cur_tot <- sum(fed_comp$Fed_tot, na.rm=TRUE)
    return(cur_tot)
}

calculate_fed_total_exp <- function(x) {
    return(sum(as.numeric(x$Fed_tot), na.rm=TRUE))
}

calculate_fws_total_exp <- function(x) {
    return(sum(as.numeric(x$FWS_tot), na.rm=TRUE))
}

calculate_other_fed_exp <- function(x) {
    return(sum(as.numeric(x$other_fed), na.rm=TRUE))
}

calculate_fed_spend_per_year <- function(x) {
    res <- tapply(x$Fed_tot,
                  INDEX=x$FY,
                  FUN=sum, na.rm=TRUE)
}

calculate_fws_spend_per_year <- function(x) {
    res <- tapply(x$FWS_tot,
                  INDEX=x$FY,
                  FUN=sum, na.rm=TRUE)
}

calculate_other_fed_spend_per_year <- function(x) {
    res <- tapply(x$other_fed,
                  INDEX=x$FY,
                  FUN=sum, na.rm=TRUE)
}

calculate_state_spend_per_year <- function(x) {
    res <- tapply(x$State_tot,
                  INDEX=x$FY,
                  FUN=sum, na.rm=TRUE)
}

calculate_total_spend_per_year <- function(x) {
    res <- tapply(x$Species_tot,
                  INDEX=x$FY,
                  FUN=sum, na.rm=TRUE)
}

calculate_n_spp_per_year <- function(x) {
    res <- tapply(x$Scientific,
                  INDEX=x$FY,
                  FUN=get_number_species)
}

##############################################################################
# Make the data writeable.
##############################################################################
make_writeable <- function(x) {
    a_copy <- x
    a_copy$spp_ev_ls <- unlist(lapply(a_copy$spp_ev_ls, FUN=paste, collapse="; "))
    a_copy$spp_BO_ls <- unlist(lapply(a_copy$spp_BO_ls, FUN=paste, collapse="| "))
    return(a_copy)
}


