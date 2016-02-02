# A Shiny Dashboard version of the section 7 app.
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

library(leaflet)

source("pages/overview_page.R")
source("pages/state_summary_page.R")
source("pages/species_page.R")
source("pages/agency_page.R")
source("pages/region_year_summary_page.R")
source("pages/time_spp_complex_page.R")
source("pages/tables_page.R")
source("pages/selected_data_page.R")
source("pages/help_page.R")
source("pages/map_page.R")

#############################################################################
# Get variables for selections
#
# To facilitate adding new data, generate the vectors from the data
regions <- c("All", levels(full$region))
ESOs <- c("All", levels(full$ESOffice))
years <- as.numeric(levels(full$FY))
agencies <- c("All", levels(full$lead_agency))
cons_types <- c("All", levels(full$consult_type))
cons_complx <- c("All", levels(full$consult_complex))
work_cats <- c("All", levels(full$work_category))
formal_cons_choice <- c("All", "Yes", "No")
states <- c("All", "AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DE", "FL", "GA", 
             "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", 
             "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", 
             "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", 
             "UT", "VA", "VT", "WA", "WI", "WV", "WY")

#############################################################################
# Define the header
header <- dashboardHeader(title="ESA Consultations")


#############################################################################
# Define the sidebar
sidebar <- dashboardSidebar(
               sidebarMenu(
                   menuItem(a(href="http://defenders.org", 
                              img(src="01_DOW_LOGO_COLOR_100.png"))),

                   menuItem(actionButton("get_started", "Getting Started")),

                   menuItem("Overview",
                            tabName="overview",
                            icon=icon("th-large")
                   ),

                   menuItem(
                       popify(
                           span(style=make_14_bold_gold(), 
                                "Choose filter criteria"),
                           title="Step 1",
                           content="Open the selection menus by clicking the dropdowns below, then select filter criteria. You may click the dropdowns a second time to 'fold' them back up once filter criteria have been made.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       tabName=""
                   ),

                   # Put the data selection options under one menuItem
                   menuItem("Who, What, When, Where",
                       tabName="cond_data_selection",
                       icon=icon("sliders"),
                       sliderInput(
                           inputId="FY",
                           label="Fiscal Year",
                           min=min(years),
                           max=max(years),
                           value=c(min(years), max(years)),
                           step=1,
                           sep="",
                           width="95%"
                       ),
                       popify(
                           selectInput(
                               inputId="state",
                               label="State",
                               choices=states,
                               selected="All",
                               multiple=TRUE,
                               width="95%"
                           ),
                           title="CAUTION: State selection",
                           content="Because the boundaries of several ES Offices cross state boundaries, take the totals (e.g., number of consultations) as an approximation. CA/NV/OR, IA/IL, and New England states are each susceptible to this issue. See the Map View page for coverage area of each ES Office.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       selectInput(
                           inputId="species",
                           label="Species",
                           choices=species,
                           selected="All",
                           multiple=TRUE,
                           width="95%"
                       ),
                       popify(
                           selectInput(
                               inputId="formal_consult",
                               label="Formal consult?",
                               choices=formal_cons_choice,
                               selected="All",
                               width="95%"
                           ),
                           title="Formal vs. Informal consultation",
                           content="A consultation will go to 'Formal' status if the action agency or FWS determines an action is likely to adversely affect one or more species. See the Glossary and consultation diagram on the 'Section 7 information' page. Select 'Yes' to view only formal consultations, 'No' to view only informal.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       popify(
                           selectInput(
                               inputId="region",
                               label="FWS Region",
                               choices=regions,
                               selected="All",
                               multiple=TRUE,
                               width="95%"
                           ),
                           title="Fish and Wildlife Service Regions",
                           content="A map of FWS regions can be found at http://www.fws.gov/Endangered/regions/index.html",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       popify(
                           selectInput(
                               inputId="ESFO",
                               label="ES Office",
                               choices=ESOs,
                               selected="All",
                               multiple=TRUE,
                               width="95%"
                           ),
                           title="ES Office",
                           content="ES = Ecological Services. Approximate ES Office boundaries are available on the Map View page.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       popify(
                           selectInput(
                               inputId="lead_agency",
                               label="Lead Agency",
                               choices=agencies,
                               selected="All",
                               multiple=TRUE,
                               width="95%"
                           ),
                           title="Lead Agency Caveat",
                           content="Note that the lead agency recorded by FWS may not be the federal action agency for consultation. Instead, many applicant agencies are recorded as the lead.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       selectInput(
                           inputId="action_category",
                           label="Work Category",
                           choices=work_cats,
                           selected="All",
                           multiple=TRUE,
                           width="95%"
                       ),
                       selectInput(
                           inputId="cons_complex",
                           label="Consult. Complexity",
                           choices=cons_complx,
                           selected="All",
                           multiple=TRUE,
                           width="95%"
                       ),
                       selectInput(
                           inputId="consult_type",
                           label="Consult. Type",
                           choices=cons_types,
                           selected="All",
                           multiple=TRUE,
                           width="95%"
                       )
                   ),

                   menuItem("Select Outcomes",
                       tabName="outcome_data_selection",
                       icon=icon("sliders"),
                       selectInput(
                           inputId="noeff",
                           label="No Effect",
                           choices=c("All", "Yes", "No"),
                           selected="All",
                           width="95%"
                       ),
                       popify(
                           selectInput(
                               inputId="nlaa",
                               label="NLAA?",
                               choices=c("All", "Yes", "No"),
                               selected="All",
                               width="95%"
                           ),
                           title="Not Likely to Adversely Affect",
                           content="An NLAA determination means that the action will not harm, and may benefit, the species being consulted on.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       selectInput(
                           inputId="concur",
                           label="Concurrence?",
                           choices=c("All", "Yes", "No"),
                           selected="All",
                           width="95%"
                       ),
                       popify(
                           selectInput(
                               inputId="jeopardy",
                               label="Jeopardy?",
                               choices=c("All", "Yes", "No"),
                               selected="All",
                               width="95%"
                           ),
                           title="Jeopardy",
                           content="Select 'Yes' to view consultations that FWS determined were likely to jeopardize the existence of one or more listed species. See the Glossary on the 'Section 7 information' page for more information.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       popify(
                           selectInput(
                               inputId="admod",
                               label="Adverse Mod.?",
                               choices=c("All", "Yes", "No"),
                               selected="All",
                               width="95%"
                           ),
                           title="Adverse Modification",
                           content="Select 'Yes' to view consultations that FWS determined were likely to negatively alter designated critical habitat of one or more listed species. See the Glossary on the 'Section 7 information' page for more information.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       popify(
                           selectInput(
                               inputId="rpa",
                               label="RPAs?",
                               choices=c("All", "Yes", "No"),
                               selected="All",
                               width="95%"
                           ),
                           title="Reasonable and Prudent Alternatives",
                           content="RPAs are alternatives to the proposed project that FWS and the action agency determined would reduce the likelihood of jeopardy or adverse modification. See the Glossary on the 'Section 7 information' page for more information.",
                           placement="right",
                           options=list(container="body", html="true")
                       )
                   ),

                   menuItem(
                       popify(
                           span(style=make_14_bold_gold(), "Activate selection"),
                           title="Step 2",
                           content="Click the 'Apply selection' button to activate the filter criteria from Step 1.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       tabName=""
                   ),

                   menuItem(submitButton("Apply selection")),

                   menuItem(
                       popify(
                           span(style=make_14_bold_gold(), "Browse results"),
                           title="Step 3",
                           content="Browse the results by clicking on the different 'tabs' below. Some views require that particular selections have been made: for example, the 'State Summary' only works (and only makes sense) if a state was selected in Step 1. Steps 1 and 2 may be repeated as desired.",
                           placement="right",
                           options=list(container="body", html="true")
                       ),
                       tabName=""
                   ),

                   # A menu item to go to state summary "page":
                   menuItem("State Summary",
                            tabName="state_summary",
                            icon=icon("bar-chart-o")
                   ),

                   # A menu item to go to species summary "page":
                   menuItem("Species Summary",
                            tabName="species_page",
                            icon=icon("bar-chart-o")
                   ),

                   # A menu item to go to agency summary "page":
                   menuItem("Agency Summary",
                            tabName="agency_page",
                            icon=icon("bar-chart-o")
                   ),

                   # A menu item to go to federal summary "page":
                   menuItem("By Year / FWS Region",
                            tabName="region_year_summary",
                            icon=icon("bar-chart-o")
                   ),

                   # A menu item to go to time/species/complexity
                   menuItem("By Time, Species, and More",
                            tabName="time_spp_complex",
                            icon=icon("bar-chart-o")
                   ),

                   # A menu item to go to a map page
                   menuItem("Map View",
                            tabName="map_view",
                            icon=icon("bar-chart-o")
                   ),

                   # A menu item to go to detailed tables "page":
                   menuItem("Summary Tables",
                            tabName="tables",
                            icon=icon("table")
                   ),

                   # A menu item to go to detailed tables "page":
                   menuItem("Selected Data",
                            tabName="selected_data",
                            icon=icon("table")
                   ),

                   # A menu item to go to detailed help "page":
                   menuItem("Section 7 information",
                            tabName="help",
                            icon=icon("question-circle")
                   )
               )
           )


#############################################################################
# Define the page(s) with dashboardBody
#
# The main body of the app is defined in this block. As with the header and 
# sidebar, ensure references to plots, tables, etc. point to the relevant app
# subdirectories, e.g., plot/, table/, etc.
#
# See ?dashboardBody, ?tabItems, ?box, and others for more info on options.
#
body <- dashboardBody(
    tabItems(
        overview_page,
        state_summary_page,
        species_page,
        agency_page,
        region_year_summary_page,
        time_spp_complex_page,
        map_page,
        tables_page,
        selected_data_page,
        help_page
    ),
    bsModal(id="instructions",
            title="How do I use this app?",
            trigger="get_started",
            includeMarkdown("txt/getting_started.md"),
            size="large"
    )
)

dashboardPage(header, sidebar, body, skin="blue")

