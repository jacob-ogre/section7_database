# Server-side code for the section 7 app overview page.
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
# Front-page values and figures
###########################################################################
server_overview <- function(input, output, selected, session) {
    output$num_consult <- renderText({
        get_number_consults(full)
    })

    output$num_formal_consult <- renderText({
        get_number_formal(full)
    })

    output$num_years <- renderText({
        get_number_years(full)
    })

    output$n_spp_total <- renderText({
        get_number_species()
    })

    output$n_agencies_total <- renderText({
        get_number_agencies(full)
    })

    output$n_personnel_total <- renderText({
        get_number_personnel(full)
    })

    output$n_consult_time_plot <- renderUI({
        title <- "FWS section 7 consultations (Jan 2008 - May 2015)"
        make_all_consult_summary_plot(full, title=title)
    })

    output$sec7_intro <- renderImage({
        # height <- session$clientData$output_sec7_overview_height
        # width <- session$clientData$output_sec7_overview_width
        list(src = "www/simple_section7_diagram_v2.png",
             contentType = "image/png",
             alt = "Overview of section 7 consultation",
             height=410)
        
    }, deleteFile=FALSE)

}

