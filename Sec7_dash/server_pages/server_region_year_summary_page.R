# Server-side code for region/year page of section 7 app.
# Copyright © 2015 Defenders of Wildlife, jmalcom@defenders.org

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

###########################################################################
# State summary page values and figures
###########################################################################
server_region_year_summary <- function(input, output, selected) {
    output$by_region_plot <- renderUI({
        make_by_region_plot(selected)
    })

    output$consult_region_personnel_plot <- renderUI({
        make_consult_region_personnel_plot(selected)
    })

    output$by_fy_plot <- renderUI({
        make_by_fy_plot(selected)
    })

    output$consult_year_personnel_plot <- renderUI({
        make_consult_year_personnel_plot(selected)
    })

}
