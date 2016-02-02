# Server-side code for the section 7 app tables page.
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


###########################################################################
# Basic summary statistics of section 7 database
###########################################################################
server_tables_page <- function(input, output, selected) {
    output$count_summary <- renderDataTable(
        make_count_summary(selected, full),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

    output$time_species_summary <- renderDataTable(
        make_time_species_summary(selected, full),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

    output$formal_consult_summary <- renderDataTable(
        make_formal_consult_summary(selected, full),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

    output$agency_summary <- renderDataTable(
        make_agency_summary(selected, full),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

    output$work_cat_summary <- renderDataTable(
        make_work_cat_summary(selected, full),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

    output$species_summary <- renderDataTable(
        make_species_summary(selected, full),
        options = list(paging=FALSE, searching=FALSE, info=FALSE, ordering=FALSE)
    )

}

