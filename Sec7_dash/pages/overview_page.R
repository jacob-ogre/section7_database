# Code for the Overview "page" (tabItem) of section 7 app.
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
# tabItem page information for the Overview page of the section 7 app
overview_page <- {
    tabItem(tabName="overview",
            fluidRow(
                column(width=12,
                       box(title=div(style=make_24_bold(), "Fish and Wildlife Service Endangered Species Act Consultations"),
                           status=NULL,
                           solidHeader=FALSE,
                           height=NULL,
                           width=NULL,
                           overview_statement()
                       )
                )
            ),

            fluidRow(
                column(width=6,
                    popify(
                        htmlOutput("n_consult_time_plot"),
                        title="Consultation rates have declined",
                        content="Notice that the total number of consultations and the number of formal consultations has steadily declined since 2008. See the Help Page for more information about section 7 consultation and associated terminology.",
                        options=list(container="body", html="true")
                    )
                ),
                column(width=3,
                       valueBox(
                           value=textOutput("num_consult"),
                           subtitle="Total number of consultations",
                           icon=icon("list"),
                           color="blue",
                           width=NULL
                       ),
                       valueBox(
                           value=textOutput("num_formal_consult"),
                           subtitle="Number of formal consultations",
                           icon=icon("list"),
                           color="blue",
                           width=NULL
                       ),
                       valueBox(
                           value=textOutput("num_years"),
                           subtitle="Years of consultations",
                           icon=icon("calendar"),
                           color="blue",
                           width=NULL
                       )
                ),
                column(width=3,
                       valueBox(
                           value=textOutput("n_spp_total"),
                           subtitle="Number of species consulted on",
                           icon=icon("list"),
                           color="blue",
                           width=NULL
                       ),
                       valueBox(
                           value=textOutput("n_agencies_total"),
                           subtitle="Number of agencies consulting",
                           icon=icon("list"),
                           color="blue",
                           width=NULL
                       ),
                       valueBox(
                           value=textOutput("n_personnel_total"),
                           subtitle="Number of FWS biologists",
                           icon=icon("users"),
                           color="blue",
                           width=NULL
                       )
                )
            ),
            tags$hr(),
            
            # Row of box-es with summary/overview information.
            fluidRow(
                column(6,
                    box(title="The section 7 consultation process",
                        status="primary",
                        solidHeader=TRUE,
                        height=510,
                        width=NULL,
                        imageOutput("sec7_intro"),
                        helpText("For more information and a detailed glossary,
                                 see the 'Section 7 information' page (linked 
                                 at bottom of the sidebar).")
                    )
                ),
                column(6,
                    box(title="Notes",
                        status="warning",
                        solidHeader=TRUE,
                        height=NULL,
                        width=NULL,
                        includeMarkdown("txt/caution_text.md")                           
                    )
                )
            ),
            tags$hr(),
            fluidRow(
                column(3),
                column(6,
                    tags$div(HTML(defenders_cc()), style=center_text)
                ),
                column(3)
            )
    )
}

