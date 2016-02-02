# Code for the help "page" (tabItem) of Expenditures app.
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

#############################################################################
# tabItem page information for the map page
map_page <- {
    tabItem(tabName="map_view",
            fluidRow(
                column(12,
                    box(title="Consultations by ES Field Office",
                        status="primary",
                        solidHeader=TRUE,
                        collapsible=FALSE,
                        height=NULL,
                        width=NULL,
                        leafletOutput("basic_map", height=600),
                        helpText("Data shown is based on selection criteria. A
                                 small number of ES Offices are not shown 
                                 because of office name changes. Office boundaries
                                 are close approximations of FWS coverage areas."
                        )
                    )
                )
            )
    )
}
