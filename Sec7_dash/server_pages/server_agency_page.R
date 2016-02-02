# Server-side code for the section 7 app agency summary page.
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
# Agency summary page values and figures
###########################################################################
server_agency_summary <- function(input, output, selected) {
    output$agency_n_consult <- renderText({
        sub <- get_number_consults(selected())
        # all <- get_number_consults(full)
        # pct <- paste(round_ratio(sub, all, 2), "%", sep="")
        # res <- paste(sub, " (", pct, " of US)", sep="")
        ifelse(input$lead_agency=="All",
               "-",
               sub #res
        )
    })

    output$agency_n_formal <- renderText({
        sub <- get_number_formal(selected())
        # all <- get_number_consults(selected())
        # pct <- paste(round_ratio(sub, all, 2), "%", sep="")
        # res <- paste(sub, " (", pct, " of species)", sep="")
        ifelse(input$lead_agency=="All",
               "-",
               sub #res
        )
    })

    output$agency_med_time_consult <- renderText({
        sub <- calculate_median_time(selected())
        # all <- calculate_median_time(full)
        # res <- paste(sub, " (days, vs. ", all, "d US)", sep="")
        res <- paste(sub, "days")
        ifelse(input$lead_agency=="All",
               "-",
               res
        )
    })

    output$agency_med_time_formal <- renderText({
        sub <- calculate_median_formal_time(selected())
        # all <- calculate_median_formal_time(full)
        # res <- paste(sub, " (days, vs. ", all, "d US)", sep="")
        res <- paste(sub, "days")
        ifelse(input$lead_agency=="All",
               "-",
               res
        )
    })

    output$agency_n_jeop <- renderText({
        ifelse(input$lead_agency=="All",
               "-",
               calculate_n_jeop_cons(selected())
        )
    })

    output$agency_n_admod <- renderText({
        ifelse(input$lead_agency=="All",
               "-",
               calculate_n_admod_cons(selected())
        )
    })

    output$cur_agency_n_ESO <- renderText({
        ifelse(input$lead_agency=="All",
               "-",
               get_number_ESFO(selected())
        )
    })

    output$cur_agency_n_species <- renderText({
        ifelse(input$lead_agency=="All",
               "-",
               calculate_state_n_spp(selected())
        )
    })

    output$agency_summary_figure <- renderUI({
        make_agency_summary_figure(selected, input$lead_agency)
    })

    output$agency_by_ESO_plot <- renderUI({
        make_agency_by_ESO_plot(selected, input$lead_agency)
    })

    output$agency_by_species_plot <- renderUI({
        make_agency_by_species_plot(selected, input$lead_agency)
    })

    output$agency_by_work_cat_plot <- renderUI({
        make_agency_by_work_category_plot(selected, input$lead_agency)
    })

    output$agency_by_complex_plot <- renderUI({
        make_agency_by_cons_complex_plot(selected, input$lead_agency)
    })

    output$agency_by_formal_plot <- renderUI({
        make_agency_by_formal_plot(selected, input$lead_agency)
    })
}

