# A Shiny Dashboard version of the End. Sp. expenditures app.
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

source("server_pages/server_overview_page.R")
source("server_pages/server_region_year_summary_page.R")
source("server_pages/server_state_summary_page.R")
source("server_pages/server_species_page.R")
source("server_pages/server_agency_page.R")
source("server_pages/server_time_spp_complex.R")
source("server_pages/server_tables_page.R")
source("server_pages/server_map_page.R")
source("server_pages/server_help_page.R")

#############################################################################
# Define the server with calls for data subsetting and making figures
#############################################################################
shinyServer(function(input, output, session) {

    # The basic reactive subsetting function
    selected <- reactive({
        sub_df(full,
               input$region,
               input$FY,
               input$ESFO,
               input$lead_agency,
               input$action_category,
               input$cons_complex,
               input$consult_type,
               input$noeff,
               input$nlaa,
               input$concur,
               input$jeopardy,
               input$admod,
               input$rpa,
               input$species,
               input$state,
               input$formal_consult
        )
    })

    # Function call to return the input variable
    output$cur_state <- renderText({
        ifelse(input$state != "All",
               input$state,
               "Please select one state to summarize"
        )
    })

    # Function call to return the input variable
    output$cur_species <- renderText({
        if (length(input$species) > 1) {
            return(too_many_species())
        } else if (input$species != "All") {
            return(input$species)
        } else {
            return("Please select one species to summarize")
        }
    })

    output$cur_agency <- renderText({
        ifelse(input$lead_agency != "All",
               input$lead_agency,
               "Please select one agency to summarize"
        )
    })

    output$cur_date_range <- renderText({
        get_year_range(selected())[1]
    })

    output$state_date_range <- renderText({
        ifelse(input$state != "All",
               get_year_range(selected()),
               ""
        )
    })

    output$agency_date_range <- renderText({
        ifelse(input$lead_agency != "All",
               get_year_range(selected()),
               ""
        )
    })

    # Add in the overview functions
    server_overview(input, output, selected, session)

    # Add in the state summary functions
    server_state_summary(input, output, selected)

    # Add in the state summary functions
    server_species_summary(input, output, selected)

    # Add in the agency summary functions
    server_agency_summary(input, output, selected)

    # Add in the region/year summary functions
    server_region_year_summary(input, output, selected)

    # Add in the time/species/complexity summary functions
    server_time_spp_complex(input, output, selected)

    # Add in the time/species/complexity summary functions
    server_tables_page(input, output, selected)

    # Add in the time/species/complexity summary functions
    server_map_page(input, output, selected)

    server_help_page(input, output, session)

    output$selected_data <- renderDataTable(
        selected()[,1:48], 
        rownames=FALSE,
        filter="top", 
        extensions="ColVis", options = list(dom = 'C<"clear">lfrtip')
    )

    output$download_data <- downloadHandler(
        filename=function() {
            "selected_data.tab"
        },
        content=function(file) {
            for_write <- make_writeable(selected())
            write.table(for_write, 
                        file=file, 
                        sep="\t",
                        row.names=FALSE,
                        quote=FALSE)
        }
    )

})
