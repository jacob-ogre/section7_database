# Tables "page" (tabItem) code for End. Sp. app.
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
# Federal summary "page" (tabItem) code for End. Sp. app.
tables_page <- {
    tabItem(tabName="tables",
            fluidRow(
                column(11,
                    box(title=tags$span("Tables",
                                        style=make_18_bold()),
                        status=NULL,
                        solidHeader=FALSE,
                        height=NULL,
                        width=NULL,
                        tags$p("A set of summary tables to complement figures.")
                    )
                ),
                column(1,
                    img(src="DOW_logo_small.png", align="right")
                )
            ),
            fluidRow(
                column(6,
                    box(title="Basic statistics",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        dataTableOutput("count_summary")
                    )
                ),
                column(6,
                    box(title="Time and species statistics",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        dataTableOutput("time_species_summary")
                    )
                )
            ),
            fluidRow(
                column(12,
                    box(title="Formal consultation statistics",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        dataTableOutput("formal_consult_summary")
                    )
                )
            ),
            fluidRow(
                column(12,
                    box(title="Top 10 consulting agencies",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        dataTableOutput("agency_summary")
                    )
                )
            ),
            fluidRow(
                column(12,
                    box(title="Top 10 work categories",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        dataTableOutput("work_cat_summary")
                    )
                )
            ),
            fluidRow(
                column(12,
                    box(title="Top 10 species",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        dataTableOutput("species_summary")
                    )
                )
            ),
            fluidRow(
                column(3),
                column(6,
                    tags$div(HTML(defenders_cc()), style=center_text)
                ),
                column(3)
            )
    )
}
