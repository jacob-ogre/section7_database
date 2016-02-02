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

# library(leaflet)
# library(maptools)
# library(sp)

###########################################################################
# Make and highlight the map
###########################################################################

server_map_page <- function(input, output, selected) {

    output$basic_map <- renderLeaflet({
        to_plot <- make_map_df(selected(), eso_geo_dat@data[[1]])
        print(to_plot)
        to_plot <- ifelse(to_plot == 0 | is.na(to_plot),
                          NA,
                          to_plot)

        if(length(unique(to_plot)) > 5) {
            leg_labs <- round(quantile(to_plot[to_plot > 0], 
                                       probs = seq(0, 1, 0.2), na.rm=T), 0)
        } else {
            leg_labs <- round(quantile(to_plot[to_plot > 0], 
                                       probs = seq(0, 1, 0.5), 
                                       na.rm=T), 0)[c(1,3)]
        }
        print(leg_labs)

        # I set most manually because Alaska wraps 180 degrees and the Marianas
        # drop the southern limit way low...
        extent <- as.vector(bbox(eso_geo_dat))
        xmin <- -65
        ymin <- 10
        xmax <- -179
        ymax <- extent[4]

        if(length(unique(to_plot)) > 5 & length(unique(leg_labs)) > 1) {
            colorramp <- colorQuantile(palette = "Blues", 
                                       domain = NULL, 
                                       n = 5, 
                                       na.color = '#D0D0D0')
        } else if(length(unique(leg_labs)) == 1) {
            colorramp <- colorNumeric(palette = "Blues", 
                                      domain = NULL, 
                                      na.color = '#D0D0D0')
        } else {
            colorramp <- colorQuantile(palette = "Blues", 
                                       domain = NULL, 
                                       n = length(unique(to_plot)), 
                                       na.color = '#D0D0D0')
        }

        if (length(leg_labs) == 6 & length(unique(leg_labs)) > 1) {
            cur_legend <- my_legend(c(0, as.vector(leg_labs[2:5])),
                                    c(as.vector(leg_labs[2:6])))
        } else if (length(leg_labs) < 6 & length(unique(leg_labs)) > 1) {
            cur_legend <- my_legend(c(0, as.vector(leg_labs[2:length(leg_labs)])),
                                    as.vector(leg_labs[2:length(leg_labs)]))
        } else {
            cur_legend <- my_legend(c(0, as.vector(leg_labs[2])),
                                    as.vector(leg_labs[2]))
        }

        if (length(unique(leg_labs)) == 1) {
            fillcol <- ifelse(!is.na(to_plot),
                              "#07306B",
                              "#D0D0D0")
            legends <- data.frame(fillcol, labs=as.vector(to_plot))
            legends$dups <- duplicated(legends$labs)
            leg2 <- legends[legends$dups==FALSE, ]
            leg2 <- leg2[order(leg2$labs),]
            legend <- function(x) {
                addLegend(x,
                          "bottomright",
                          colors=unique(leg2$fillcol),
                          labels=c(unique(leg2$labs)[1:length(leg2$labs)-1], "NA"),
                          values=~to_plot,
                          na.label="NA",
                          title="Number of consultations",
                          labFormat=cur_legend)
            }
        } else if (length(unique(leg_labs)) < 5) {
            somerand <- runif(length(to_plot))
            legends <- data.frame(fillcol = colorramp(to_plot),
                                  labs = as.vector(to_plot))
            legends$dups <- duplicated(legends$labs)
            leg2 <- legends[legends$dups==FALSE, ]
            leg2 <- leg2[order(leg2$labs),]
            print(unique(leg2$fillcol))
            print(c(unique(leg2$labs)[1:length(unique(leg2$labs))-1], "NA"))
            legend <- function(x) {
                addLegend(x,
                          "bottomright", 
                          colors=unique(leg2$fillcol),
                          labels=c(unique(leg2$labs)[1:length(unique(leg2$labs))-1], "NA"),
                          # labels=
                          values = ~to_plot,
                          na.label="NA",
                          title = "Number of Consultations",
                          labFormat=cur_legend)
            }
        } else {
            somerand <- runif(length(to_plot))
            legends <- data.frame(fillcol = colorramp(to_plot + somerand),
                                  labs = as.vector(to_plot))
            legends$dups <- duplicated(legends$labs)
            leg2 <- legends[legends$dups==FALSE, ]
            leg2 <- leg2[order(leg2$labs),]
            legend <- function(x) {
                addLegend(x,
                          "bottomright", 
                          pal = colorramp, 
                          values = ~as.vector(to_plot),
                          na.label="NA",
                          title = "Number of Consultations",
                          labFormat=cur_legend)
            }
        }

        popupFormat <- paste0("<strong>", 
                              names(to_plot), 
                              "</strong>", 
                              "<br>", 
                              to_plot)

        map <- leaflet(data = eso_geo_dat) %>%
                   addPolygons(fillColor = legends$fillcol,
                               fillOpacity = 0.5, 
                               stroke = TRUE, 
                               weight = 1.5, 
                               color = "#000000", # settings for borders
                               smoothFactor = 1.1,
                               popup = popupFormat) %>% 
                   # add basemap; can be modified later
                   addTiles(urlTemplate = map_templ_url(),
                            attribution = map_attrib()) %>%
                   legend %>%
                   fitBounds(lng1 = xmax, 
                             lat1 = ymax, 
                             lng2 = xmin, 
                             lat2 = ymin)
        return(map)
    })

}

