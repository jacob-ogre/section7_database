# Code for "page" (tabItem) of additional plots for End. Sp. app.
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
selected_data_page <- {
    tabItem(tabName="selected_data",
            fluidRow(
                column(11,
                    box(title=tags$span("Selected data subset",
                                        style=make_18_bold()),
                        status=NULL,
                        solidHeader=FALSE,
                        height=NULL,
                        width=NULL
                    )
                ),
                column(1,
                    img(src="DOW_logo_small.png", align="right")
                )
            ),
            fluidRow(
                div(style="overflow-x: scroll; background-color: #FFFFFF;
                           padding-left: 15px", 
                    tags$h6("The selected data may be downloaded as a tab-
                            delimited file."),
                    downloadButton("download_data", "Download (tab-sep.)"),
                    tags$hr(),
                    dataTableOutput("selected_data")
                )
            )
    )
}

