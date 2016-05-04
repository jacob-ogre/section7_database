# Central landing page for sec7 basic app
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

source("pages/help_page.R")
source("pages/single_view_page_2.R")
source("pages/compare_page.R")
source("pages/alt_map_page.R")
source("pages/data_page.R")

###############################################################################
# Central landing page for sec7 basic app
results_page <- {
    navbarPage(title = div(class = "btn-group",
                           bsButton("get_started",
                                    label="Help",
                                    style="warning"
                           ),
                           bsButton(inputId = "filter_data",
                                    label = "Filter data",
                                    style = "primary"
                           )
                       ),
        single_view_page,
        navbarMenu(title="More info",
            tabPanel(title = "Comparison page",
                     compare_page),
            tabPanel(title="Alternate map",
                     alt_map_page),
            tabPanel(title="Data",
                     data_page),
            tabPanel(title="Sec. 7 background",
                     help_page)
        ),
        inverse=TRUE,
        position="fixed-top"
    )
}

