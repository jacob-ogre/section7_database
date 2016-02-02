# Server-side code for the section 7 app state summary page.
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

server_help_page <- function(input, output, session) {
    output$sec7_overview <- renderImage({
        height <- session$clientData$output_sec7_overview_height
        width <- session$clientData$output_sec7_overview_width
        list(src = "www/simple_section7_diagram_v2.png",
             contentType = "image/png",
             alt = "Overview of section 7 consultation",
             height=height,
             width=width)
        
    }, deleteFile=FALSE)

}

