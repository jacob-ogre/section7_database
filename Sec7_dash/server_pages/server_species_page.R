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


###########################################################################
# State summary page values and figures
###########################################################################
server_species_summary <- function(input, output, selected) {
    output$species_n_consult <- renderText({
        sub <- get_number_consults(selected())
        ifelse(input$species=="All",
               "-",
               sub
        )
    })

    output$species_n_formal <- renderText({
        sub <- get_number_formal(selected())
        ifelse(input$species=="All",
               "-",
               sub
        )
    })

    output$species_med_time_consult <- renderText({
        sub <- calculate_median_time(selected())
        res <- paste(sub, "days")
        ifelse(input$species=="All",
               "-",
               res
        )
    })

    output$species_med_time_formal <- renderText({
        sub <- calculate_median_formal_time(selected())
        res <- paste(sub, "days")
        ifelse(input$species=="All",
               "-",
               res
        )
    })

    output$species_n_jeop <- renderText({
        if(input$species=="All") {
           return("-")
        } else {
            asp <- input$species
            sci_pat <- regmatches(asp, gregexpr("(?<=\\().*?(?=\\))", asp, perl=T))[[1]]
            com_pat <- strsplit(asp, split=" (", fixed=T)[[1]][1]
            sci_mat <- grep(sci_pat, sp_ja_dat$sci_name, fixed=T)
            com_mat <- grep(com_pat, sp_ja_dat$common_name, fixed=T)
            if (length(sci_mat) > 0 & 
                sp_ja_dat[sci_mat[1],]$rescinded=="Y" & 
                sp_ja_dat[sci_mat[1],]$Jeopardy=="Y") {
                return(paste(length(sci_mat), "(rescinded)", sep=""))
            } else if (length(sci_mat) > 0 & 
                       sp_ja_dat[sci_mat[1],]$rescinded=="N" & 
                       sp_ja_dat[sci_mat[1],]$Jeopardy=="Y") {
                return(length(sci_mat))
            } else if (length(com_mat) > 0 & 
                       sp_ja_dat[com_mat[1],]$rescinded=="Y" & 
                       sp_ja_dat[com_mat[1],]$Jeopardy=="Y") {
                return(paste(length(com_mat), "(rescinded)", sep=""))
            } else if (length(com_mat) > 0 & 
                       sp_ja_dat[com_mat[1],]$rescinded=="N" & 
                       sp_ja_dat[com_mat[1],]$Jeopardy=="Y") {
                return(length(com_mat))
            } else {
                return(0)
            }
        }
    })

    output$species_n_admod <- renderText({
        if(input$species=="All") {
           return("-")
        } else {
            asp <- input$species
            sci_pat <- regmatches(asp, gregexpr("(?<=\\().*?(?=\\))", asp, perl=T))[[1]]
            com_pat <- strsplit(asp, split=" (", fixed=T)[[1]][1]
            sci_mat <- grep(sci_pat, sp_ja_dat$sci_name, fixed=T)
            com_mat <- grep(com_pat, sp_ja_dat$common_name, fixed=T)
            if (length(sci_mat) > 0 & 
                sp_ja_dat[sci_mat[1],]$rescinded=="Y" & 
                sp_ja_dat[sci_mat[1],]$AdMod=="Y") {
                return(paste(length(sci_mat), "(rescinded)", sep=""))
            } else if (length(sci_mat) > 0 & 
                       sp_ja_dat[sci_mat[1],]$rescinded=="N" & 
                       sp_ja_dat[sci_mat[1],]$AdMod=="Y") {
                return(length(sci_mat))
            } else if (length(com_mat) > 0 & 
                       sp_ja_dat[com_mat[1],]$rescinded=="Y" & 
                       sp_ja_dat[com_mat[1],]$AdMod=="Y") {
                return(paste(length(com_mat), "(rescinded)", sep=""))
            } else if (length(com_mat) > 0 & 
                       sp_ja_dat[com_mat[1],]$rescinded=="N" & 
                       sp_ja_dat[com_mat[1],]$AdMod=="Y") {
                return(length(com_mat))
            } else {
                return(0)
            }
        }
    })

    output$cur_species_n_ESO <- renderText({
        ifelse(input$species=="All",
               "-",
               get_number_ESFO(selected())
        )
    })

    output$cur_species_n_agencies <- renderText({
        ifelse(input$species=="All",
               "-",
               get_number_agencies(selected())
        )
    })

    output$species_summary_figure <- renderUI({
        make_species_summary_figure(selected, input$species)
    })

    output$species_by_ESO_plot <- renderUI({
        make_species_by_ESO_plot(selected, input$species)
    })

    output$species_by_agency_plot <- renderUI({
        make_species_by_agencies_plot(selected, input$species)
    })

    output$species_by_work_cat_plot <- renderUI({
        make_species_by_work_category_plot(selected, input$species)
    })

    output$species_by_complex_plot <- renderUI({
        make_species_by_cons_complex_plot(selected, input$species)
    })

    output$species_by_formal_plot <- renderUI({
        make_species_by_formal_plot(selected, input$species)
    })
}

