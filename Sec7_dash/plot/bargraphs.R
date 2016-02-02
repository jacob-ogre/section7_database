# Bargraphs for the section 7 Shiny app.
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
# Plots for State page
#############################################################################
#############################################################################

#############################################################################
# State consultation summary barchart
make_state_summary_figure <- function(dat, cur_state) {
    if (length(cur_state) > 1) {
        return(tags$p(too_many_states()))
    } else if (cur_state == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_consult_year_summary_df(dat())
    consults <- list_xy_data(cur_dat$years, cur_dat$cons_yr, "All", "bar")
    formal <- list_xy_data(cur_dat$years, cur_dat$form_yr, "Formal", "bar")
    data <- list(consults, formal)
    return_plotly(data, height=350, width="100%",
                  l=50, t=30, b=50, r=50,
                  ylab="Number of Consultations"
    )
}

#############################################################################
# State species summary barchart
make_state_species_plot <- function(dat, cur_state) {
    if (length(cur_state) > 1) {
        return(tags$p(too_many_states()))
    } else if (cur_state == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_species_df(dat())
    data <- list_xy_data(cur_dat$species, 
                         cur_dat$consultations, 
                         "spending", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State agencies summary barchart
make_state_agencies_plot <- function(dat, cur_state) {
    if (length(cur_state) > 1) {
        return(tags$p(too_many_states()))
    } else if (cur_state == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_agencies_df(dat())
    data <- list_xy_data(cur_dat$agency, 
                         cur_dat$consultations, 
                         "agency", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State work categories summary barchart
make_state_work_category_plot <- function(dat, cur_state) {
    if (length(cur_state) > 1) {
        return(tags$p(too_many_states()))
    } else if (cur_state == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_work_cat_df(dat())
    data <- list_xy_data(cur_dat$work_cat, 
                         cur_dat$consultations, 
                         "work_cat", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State consult complexity summary barchart
make_state_cons_complex_plot <- function(dat, cur_state) {
    if (length(cur_state) > 1) {
        return(tags$p(too_many_states()))
    } else if (cur_state == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_cons_complex_df(dat())
    data <- list_xy_data(cur_dat$complexity, 
                         cur_dat$consultations, 
                         "cons_complex", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State formal consult summary barchart
make_state_formal_plot <- function(dat, cur_state) {
    if (length(cur_state) > 1) {
        return(tags$p(too_many_states()))
    } else if (cur_state == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_formal_df(dat())
    data <- list_xy_data(cur_dat$formal, 
                         cur_dat$consultations, 
                         "formal_cons", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=70, r=50,
                  ylab="Number of consultations",
                  xlab="Formal consultation?"
    )
}

#############################################################################
#############################################################################
# Plots for Species page
#############################################################################
#############################################################################

#############################################################################
# Species consultation summary barchart
make_species_summary_figure <- function(dat, cur_species) {
    if (length(cur_species) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_species == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_consult_year_summary_df(dat())
    consults <- list_xy_data(cur_dat$years, cur_dat$cons_yr, "All", "bar")
    formal <- list_xy_data(cur_dat$years, cur_dat$form_yr, "Formal", "bar")
    data <- list(consults, formal)
    return_plotly(data, height=350, width="100%",
                  l=50, t=30, b=50, r=50,
                  ylab="Number of Consultations"
    )
}

#############################################################################
# ESOs for species page plot
make_species_by_ESO_plot <- function(dat, cur_species) {
    if (length(cur_species) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_species == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_species_by_ESO_df(dat())
    data <- list_xy_data(cur_dat$offices, 
                         cur_dat$consultations, 
                         "spending", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# Species by agencies summary barchart
make_species_by_agencies_plot <- function(dat, cur_species) {
    if (length(cur_species) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_species == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_agencies_df(dat())
    data <- list_xy_data(cur_dat$agency, 
                         cur_dat$consultations, 
                         "agency", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State work categories summary barchart
make_species_by_work_category_plot <- function(dat, cur_species) {
    if (length(cur_species) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_species == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_work_cat_df(dat())
    data <- list_xy_data(cur_dat$work_cat, 
                         cur_dat$consultations, 
                         "work_cat", 
                         "bar")

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
#############################################################################
# Plots for Agency page
#############################################################################
#############################################################################

#############################################################################
# Agency consultation summary barchart
make_agency_summary_figure <- function(dat, cur_agency) {
    if (length(cur_agency) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_agency == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_consult_year_summary_df(dat())
    consults <- list_xy_data(cur_dat$years, cur_dat$cons_yr, "All", "bar")
    formal <- list_xy_data(cur_dat$years, cur_dat$form_yr, "Formal", "bar")
    data <- list(consults, formal)
    return_plotly(data, height=375, width="100%",
                  l=50, t=30, b=50, r=50,
                  ylab="Number of Consultations"
    )
}

#############################################################################
# ESOs for agency page plot
make_agency_by_ESO_plot <- function(dat, cur_agency) {
    if (length(cur_agency) > 1) {
        return(tags$p(too_many_agency()))
    } else if (cur_agency == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_species_by_ESO_df(dat())
    data <- list_xy_data(cur_dat$offices, 
                         cur_dat$consultations, 
                         "spending", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# Agency by species summary barchart
make_agency_by_species_plot <- function(dat, cur_agency) {
    if (length(cur_agency) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_agency == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_top_100_species_df(dat())
    data <- list_xy_data(cur_dat$species, 
                         cur_dat$consultations, 
                         "species", 
                         "bar")

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State work categories summary barchart
make_agency_by_work_category_plot <- function(dat, cur_agency) {
    if (length(cur_agency) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_agency == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_work_cat_df(dat())
    data <- list_xy_data(cur_dat$work_cat, 
                         cur_dat$consultations, 
                         "work_cat", 
                         "bar")

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State consult complexity summary barchart
make_agency_by_cons_complex_plot <- function(dat, cur_agency) {
    if (length(cur_agency) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_agency == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_cons_complex_df(dat())
    data <- list_xy_data(cur_dat$complexity, 
                         cur_dat$consultations, 
                         "cons_complex", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State formal consult summary barchart
make_agency_by_formal_plot <- function(dat, cu_agency) {
    if (cu_agency == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_formal_df(dat())
    data <- list_xy_data(cur_dat$formal, 
                         cur_dat$consultations, 
                         "formal_cons", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=70, r=50,
                  ylab="Number of consultations",
                  xlab="Formal consultation?"
    )
}

#############################################################################
# State consult complexity summary barchart
make_species_by_cons_complex_plot <- function(dat, cur_species) {
    if (length(cur_species) > 1) {
        return(tags$p(too_many_species()))
    } else if (cur_species == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_cons_complex_df(dat())
    data <- list_xy_data(cur_dat$complexity, 
                         cur_dat$consultations, 
                         "cons_complex", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# State formal consult summary barchart
make_species_by_formal_plot <- function(dat, cur_species) {
    if (cur_species == "All") {
        return(tags$p(no_data()))
    } else if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_state_formal_df(dat())
    data <- list_xy_data(cur_dat$formal, 
                         cur_dat$consultations, 
                         "formal_cons", 
                         "bar")
    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=70, r=50,
                  ylab="Number of consultations",
                  xlab="Formal consultation?"
    )
}

#############################################################################
#############################################################################
# Plots for Region/Time page
#############################################################################
#############################################################################

#############################################################################
# Consults by region
make_by_region_plot <- function(dat) {
    if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_by_region_df(dat())
    consults <- list_xy_data(cur_dat$region, 
                             cur_dat$all_consult, 
                             "All consult.", 
                             "bar",
                             opacity=1)
    formal <- list_xy_data(cur_dat$region, 
                           cur_dat$formal_consult, 
                           "Formal", 
                           "bar",
                           opacity=0.8)
    data <- list(consults, formal)

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=70, r=50,
                  barmode="overlay",
                  ylab="Number of consultations",
                  xlab="FWS Region"
    )
}

#############################################################################
# Consults by FY
make_by_fy_plot <- function(dat) {
    if (dim(dat())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_by_fy_df(dat())
    consults <- list_xy_data(cur_dat$year, 
                             cur_dat$all_consult, 
                             "All consult.", 
                             "bar",
                             opacity=1)
    formal <- list_xy_data(cur_dat$year, 
                           cur_dat$formal_consult, 
                           "Formal", 
                           "bar",
                           opacity=0.8)
    data <- list(consults, formal)

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=70, r=50,
                  barmode="overlay",
                  ylab="Number of consultations",
                  xlab="Fiscal Year"
    )
}

#############################################################################
# Consults by FY
make_sorted_state_spend_plot <- function(state) {
    if (dim(state())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_sorted_state_spend_df(state())
    data <- list_xy_data(cur_dat$state, cur_dat$spend, "spending", "bar")

    return_plotly(data, height=300, width="100%",
                  l=50, t=30, b=100, r=50,
                  ylab="Expenditures ($)"
    )
}

#############################################################################
# Top 100 species summary barchart
make_top_100_species_plot <- function(sub) {
    if (dim(sub())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_top_100_species_df(sub())
    data <- list_xy_data(cur_dat$species, 
                         cur_dat$consultations, 
                         "spending", 
                         "bar")

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# Top 100 agencies summary barchart
make_top_100_agencies_plot <- function(sub) {
    if (dim(sub())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_top_100_agencies_df(sub())
    data <- list_xy_data(cur_dat$agencies, 
                         cur_dat$consultations, 
                         "spending", 
                         "bar")

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}

#############################################################################
# Top 100 work_cat summary barchart
make_top_100_work_cat_plot <- function(sub) {
    if (dim(sub())[1] < 1) {
        return(tags$p(no_data()))
    }
    cur_dat <- make_top_100_work_cat_df(sub())
    data <- list_xy_data(cur_dat$work_cat, 
                         cur_dat$consultations, 
                         "spending", 
                         "bar")

    return_plotly(data, height=400, width="100%",
                  l=50, t=30, b=120, r=50,
                  ylab="Number of consultations"
    )
}


