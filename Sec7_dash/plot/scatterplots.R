# Scatterplot template function for Shiny apps.
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

###############################################################################
# Front-page consultation summary plotly figure (for all data)
make_all_consult_summary_plot <- function(dat, title) {
    if (dim(dat)[1] == 0) {
        return(tags$p("Data did not load"))
    }
    cur_dat <- make_consult_year_summary_df(dat)
    consults <- list_xy_data(cur_dat$years, cur_dat$cons_yr, "All", "scatter")
    formal <- list_xy_data(cur_dat$years, cur_dat$form_yr, "Formal", "scatter")
    data <- list(consults, formal)

    return_plotly(data, ylab="Number of consultations", title=title,
                  t=40, b=40, l=50, r=50,
                  height=350, width="100%"
    )
}

###############################################################################
# Summary of n_consult by n_person, grouped by region
make_consult_region_personnel_plot <- function(dat) {
    if (dim(dat())[1] == 0) {
        return(tags$p("No data"))
    }
    cur_dat <- make_consult_region_personnel_df(dat())
    data <- list_xy_data(cur_dat$pers_cnt, 
                         cur_dat$cons_cnt, 
                         name="All", 
                         mode="markers",
                         text=cur_dat$region,
                         type="scatter",
                         marker=list(size=12, 
                                     color=colorblind(),
                                     line=list(color="black",
                                               width=0.5)
                                     )
                         )
    return_plotly(data, ylab="Number of consultations", xlab="Number of personnel",
                  t=40, b=70, l=50, r=50,
                  height=400, width="100%"
    )
}

###############################################################################
# Summary of n_consult by n_person, grouped by year
make_consult_year_personnel_plot <- function(dat) {
    if (dim(dat())[1] == 0) {
        return(tags$p("No data"))
    }
    cur_dat <- make_consult_year_personnel_df(dat())
    data <- list_xy_data(cur_dat$pers_cnt, 
                         cur_dat$cons_cnt, 
                         name="All", 
                         mode="markers",
                         text=cur_dat$year,
                         type="scatter",
                         marker=list(size=12, 
                                     color=colorblind(),
                                     line=list(color="black",
                                               width=0.5)
                                     )
                         )
    return_plotly(data, ylab="Number of consultations", xlab="Number of personnel",
                  t=40, b=70, l=50, r=50,
                  height=400, width="100%"
    )
}

