# Section 7 summary information by region/year.
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
# Summary information by region/year
region_year_summary_page <- {
    tabItem(tabName="region_year_summary",
            fluidRow(
                column(11,
                    box(title=tags$span("Summaries by FWS region and fiscal year",
                                        style=make_18_bold()),
                        status=NULL,
                        solidHeader=FALSE,
                        height=NULL,
                        width=NULL,
                        tags$h5("For selected data")
                    )
                ),
                column(1,
                    img(src="DOW_logo_small.png", align="right")
                )
            ),
            fluidRow(
                column(6,
                    box(title="Consultations by FWS region",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("by_region_plot")
                    )
                ),
                column(6,
                    box(title="Consultations by number of personnel (region)",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("consult_region_personnel_plot")
                    )
                )
            ),
            fluidRow(
                column(6,
                    box(title="Consultations by fiscal year",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("by_fy_plot")
                    )
                ),
                column(6,
                    box(title="Consultations by number of personnel (year)",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("consult_year_personnel_plot")
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
