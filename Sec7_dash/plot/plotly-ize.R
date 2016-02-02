# Helper functions to convert ggplot figures into plotly figures.
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

source("support/random_string.R")

return_plotly <- function(x, fileopt="overwrite",
                          height=500, width="100%",
                          l=100, t=100, r=100, b=100,
                          barmode="group",
                          ylab="", xlab="", title="") {
    layout <- list(margin=list(l=l, t=t, r=r, b=b),
                   yaxis=list(title=ylab),
                   xaxis=list(title=xlab),
                   barmode=barmode,
                   title=title)

    py <- plotly()
    res <- py$plotly(x, kwargs=list(
                     layout=layout,
                     filename=rand_str(),
                     fileopt="overwrite"))

    tmp <- tags$object(type="text/html", 
                       data=res$url, 
                       height=height, 
                       width=width,
               tags$embed(src=res$url,
                          frameBorder="0",
                          height=height,
                          width=width
               )
           )
    return(tmp)
}

list_xy_data <- function(x, y, name="", 
                         type="bar", marker=list(), 
                         mode="",
                         text="",
                         opacity=1) {
    res <- list(x=x,
                y=y,
                name=name,
                marker=marker,
                mode=mode,
                text=text,
                opacity=opacity,
                type=type)
    return(res)
}
