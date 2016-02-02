# Server-side code for the section 7 app state summary page.
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


###########################################################################
# Time/species/complexity summary page values and figures
###########################################################################
server_time_spp_complex <- function(input, output, selected) {
    output$consult_time_hist <- renderUI({
        make_consult_time_hist(full, selected)
    })

    output$species_per_consult_hist <- renderUI({
        make_species_per_consult_hist(full, selected)
    })

    output$top_100_species_plot <- renderUI({
        make_top_100_species_plot(selected)
    })

    output$top_100_agencies_plot <- renderUI({
        make_top_100_agencies_plot(selected)
    })

    output$top_100_work_cat_plot <- renderUI({
        make_top_100_work_cat_plot(selected)
    })
    
}

