# State summary "page" (tabItem) code for End. Sp. app.
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
# State summary "page" (tabItem) code for End. Sp. app.
species_page <- {
    tabItem(tabName="species_page",
            fluidRow(
                column(11,
                    box(title=tags$span(textOutput("cur_species"), 
                                        style=make_24_bold()),
                        status=NULL,
                        solidHeader=FALSE,
                        height=NULL,
                        width=NULL,
                        textOutput("species_date_range"),
                        helpText("This page is for examining the consultation
                                 data for one species at a time; multi-species
                                 summaries can be examined on other pages.")
                    )
                ),
                column(1,
                    tags$div(style="max-width:100%; max-height:auto",
                        img(src="DOW_logo_small.png", align="right"))
                )
            ),

            fluidRow(
                column(3,
                    tipify(
                        valueBox(
                            subtitle="# consultations (all)",
                            value=textOutput("species_n_consult"),
                            color="blue",
                            icon=NULL,
                            width=NULL
                        ),
                        title="Informal & Formal"
                    ),
                    tipify(
                        valueBox(
                            subtitle="Median consultation duration (all)",
                            value=textOutput("species_med_time_consult"),
                            color="blue",
                            icon=NULL,
                            width=NULL
                        ),
                        title="Informal & Formal"
                    ),
                    tipify(
                        valueBox(
                            subtitle="# jeopardy consultations",
                            value=textOutput("species_n_jeop"),
                            color="red",
                            icon=icon("exclamation-circle"),
                            width=NULL
                        ),
                        title="Action likely to jeopardize one or more species"
                    ),
                    tipify(
                        valueBox(
                            subtitle="Number of ES Offices",
                            value=textOutput("cur_species_n_ESO"),
                            color="navy",
                            icon=NULL,
                            width=NULL
                        ),
                        title="ES = Ecological Services"
                    )
                ),

                column(3,
                    valueBox(
                        subtitle="# formal consultations",
                        value=textOutput("species_n_formal"),
                        color="orange",
                        icon=NULL,
                        width=NULL
                    ),
                    valueBox(
                        subtitle="Median consultation duration (formal)",
                        value=textOutput("species_med_time_formal"),
                        color="orange",
                        icon=NULL,
                        width=NULL
                    ),
                    tipify(
                        valueBox(
                            subtitle="# Adverse Modification consultations",
                            value=textOutput("species_n_admod"),
                            color="red",
                            icon=icon("exclamation-circle"),
                            width=NULL
                        ),
                        title="Action likely to adversely modify critical habitat"
                    ),
                    valueBox(
                        subtitle="Number of agencies consulting",
                        value=textOutput("cur_species_n_agencies"),
                        color="navy",
                        icon=NULL,
                        width=NULL
                    )
                ),

                # plot the state-level spending summary figure
                column(6,
                    box(htmlOutput("species_summary_figure"),
                        title="Consultations through time",
                        status="primary",
                        solidHeader=TRUE,
                        width=NULL,
                        height=NULL
                    )
                )
            ),

            tags$hr(),
            fluidRow(
                column(12,
                    box(title="Consultations by ES Office",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("species_by_ESO_plot")
                    ),
                    box(title="Consultations by agency",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("species_by_agency_plot")
                    ),
                    box(title="Consultations by work category",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("species_by_work_cat_plot")
                    )
                ),
                column(6,
                    box(title="Consultations by complexity",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("species_by_complex_plot")
                    )
                ),
                column(6,
                    box(title="All vs. formal consultations",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("species_by_formal_plot")
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
