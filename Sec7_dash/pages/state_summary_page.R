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
state_summary_page <- {
    tabItem(tabName="state_summary",
            fluidRow(
                column(11,
                    box(title=tags$span(textOutput("cur_state"), 
                                        style=make_18_bold()),
                        status=NULL,
                        solidHeader=FALSE,
                        height=NULL,
                        width=NULL,
                        textOutput("state_date_range"),
                        helpText("This page is designed to examine consultation
                                 data for one state; other pages may be used if
                                 multi-state selections are required.")
                    )
                ),
                column(1,
                    img(src="DOW_logo_small.png", align="right")
                )
            ),

            fluidRow(
                column(3,
                    tipify(
                        valueBox(
                            subtitle="# consultations (all)",
                            value=textOutput("state_n_consult"),
                            color="blue",
                            icon=NULL,
                            width=NULL
                        ),
                        title="Informal & Formal"
                    ),
                    tipify(
                        valueBox(
                            subtitle="Median consultation time (all)",
                            value=textOutput("state_med_time_consult"),
                            color="blue",
                            icon=NULL,
                            width=NULL
                        ),
                        title="Informal & Formal"
                    ),
                    tipify(
                        valueBox(
                            subtitle="# Jeopardy consultations",
                            value=textOutput("state_n_jeop"),
                            color="red",
                            icon=NULL,
                            width=NULL
                        ),
                        title="Action will jeopardize one or more species"
                    ),
                    valueBox(
                        subtitle="Number of species consulted on",
                        value=textOutput("cur_state_n_spp"),
                        color="navy",
                        icon=NULL,
                        width=NULL
                    )
                ),

                column(3,
                    valueBox(
                        subtitle="# formal consultations",
                        value=textOutput("state_n_formal"),
                        color="orange",
                        icon=NULL,
                        width=NULL
                    ),
                    valueBox(
                        subtitle="Median consultation duration (formal)",
                        value=textOutput("state_med_time_formal"),
                        color="orange",
                        icon=NULL,
                        width=NULL
                    ),
                    tipify(
                        valueBox(
                            subtitle="# Adverse Modification consultations",
                            value=textOutput("state_n_admod"),
                            color="red",
                            icon=NULL,
                            width=NULL
                        ),
                        title="Action will negatively affect critical habitat"
                    ),
                    tipify(
                        valueBox(
                            subtitle="Number of agencies consulting",
                            value=textOutput("cur_state_n_agencies"),
                            color="navy",
                            icon=NULL,
                            width=NULL
                        ),
                        title="See note for 'Lead Agency' selector in sidebar"
                    )
                ),

                # plot the state-level spending summary figure
                column(6,
                    box(htmlOutput("state_summary_figure"),
                        title="Summary of consultations",
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
                    box(title="Consultations by species",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("state_species_plot")
                    ),
                    box(title="Consultations by agency",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("state_agency_plot")
                    ),
                    box(title="Consultations by work category",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("state_work_cat_plot")
                    )
                ),
                column(6,
                    box(title="Consultations by complexity",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("state_complex_plot")
                    )
                ),
                column(6,
                    box(title="All vs. formal consultations",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("state_formal_plot")
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
