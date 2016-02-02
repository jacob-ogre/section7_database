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
# State summary page values and figures
###########################################################################
server_state_summary <- function(input, output, selected) {
    output$state_n_consult <- renderText({
        sub <- get_number_consults(selected())
        ifelse(input$state=="All",
               "-",
               sub
        )
    })

    output$state_n_formal <- renderText({
        sub <- get_number_formal(selected())
        ifelse(input$state=="All",
               "-",
               sub
        )
    })

    output$state_med_time_consult <- renderText({
        sub <- calculate_median_time(selected())
        res <- paste(sub, " (days)", sep="")
        ifelse(input$state=="All",
               "-",
               res
        )
    })

    output$state_med_time_formal <- renderText({
        sub <- calculate_median_formal_time(selected())
        res <- paste(sub, " (days)", sep="")
        ifelse(input$state=="All",
               "-",
               res
        )
    })

    output$state_n_jeop <- renderText({
        ifelse(input$state=="All",
               "-",
               calculate_n_jeop_cons(selected())
        )
    })

    output$state_n_admod <- renderText({
        ifelse(input$state=="All",
               "-",
               calculate_n_admod_cons(selected())
        )
    })

    output$cur_state_n_spp <- renderText({
        ifelse(input$state=="All",
               "-",
               calculate_state_n_spp(selected())
        )
    })

    output$cur_state_n_agencies <- renderText({
        ifelse(input$state=="All",
               "-",
               get_number_agencies(selected())
        )
    })

    output$state_summary_figure <- renderUI({
        make_state_summary_figure(selected, input$state)
    })

    output$state_species_plot <- renderUI({
        make_state_species_plot(selected, input$state)
    })

    output$state_agency_plot <- renderUI({
        make_state_agencies_plot(selected, input$state)
    })

    output$state_work_cat_plot <- renderUI({
        make_state_work_category_plot(selected, input$state)
    })

    output$state_complex_plot <- renderUI({
        make_state_cons_complex_plot(selected, input$state)
    })

    output$state_formal_plot <- renderUI({
        make_state_formal_plot(selected, input$state)
    })
}

