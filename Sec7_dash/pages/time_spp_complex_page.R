# Section 7 summaries for time, species, and complexity.
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
time_spp_complex_page <- {
    tabItem(tabName="time_spp_complex",
            fluidRow(
                column(11,
                    box(title=tags$span("Consultation time, species, and more",
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
                    box(title="Consultation time",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("consult_time_hist"),
                        tags$span(style="color:gray",
                            tags$p("Data trimmed at 95th percentile for viewing")
                        )
                    )
                ),
                column(6,
                    box(title="Number of species per consultation",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("species_per_consult_hist"),
                        tags$span(style="color:gray",
                            tags$p("Data trimmed at 98th percentile for viewing")
                        )
                    )
                )
            ),
            fluidRow(
                column(12,
                    box(title="Top species (limit 100)",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("top_100_species_plot")
                    )
                )
            ),
            fluidRow(
                column(12,
                    box(title="Top agencies (limit 100)",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("top_100_agencies_plot")
                    )
                )
            ),
            fluidRow(
                column(12,
                    box(title="Top work categories (limit 100)",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=TRUE,
                        height=NULL,
                        width=NULL,
                        htmlOutput("top_100_work_cat_plot")
                    )
                )
            )
        )
}

