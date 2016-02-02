# Histogram templates for Shiny apps.
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

##############################################################################
# Histogram of consultation times
make_consult_time_hist <- function(all, sub) {
    if (dim(sub())[1] < 1) {
        return(tags$p(no_data()))
    }
    pct95_all <- quantile(all$elapsed, 0.95, na.rm=T)
    med_all <- median(all$elapsed, na.rm=T)
    all_time <- list(x=all$elapsed[all$elapsed < pct95_all], 
                     opacity=0.6, 
                     type="histogram", 
                     name="All data")
    sub_time <- list(x=sub()$elapsed[sub()$elapsed < pct95_all], 
                     opacity=0.8, 
                     type="histogram", 
                     name="Selected")
    data <- list(all_time, sub_time)
    return_plotly(data, height=400, barmode="overlay", 
                  l=50, t=50, r=50, b=70,
                  ylab="Number of consultations",
                  xlab="Consultation time (days)"
    )
}

##############################################################################
# Histogram of species per consultation
make_species_per_consult_hist <- function(all, sub) {
    if (dim(sub())[1] < 1) {
        return(tags$p(no_data()))
    }
    pct98_all <- quantile(all$n_spp_eval, 0.98, na.rm=T)
    med_all <- median(all$n_spp_eval, na.rm=T)
    all_time <- list(x=all$n_spp_eval[all$n_spp_eval < pct98_all], 
                     opacity=0.6, 
                     type="histogram", 
                     name="All data")
    sub_time <- list(x=sub()$n_spp_eval[sub()$n_spp_eval < pct98_all], 
                     opacity=0.8, 
                     type="histogram", 
                     name="Selected")
    data <- list(all_time, sub_time)
    return_plotly(data, height=400, barmode="overlay", 
                  l=50, t=50, r=50, b=70,
                  ylab="Number of consultations",
                  xlab="Species per consultation"
    )
}

