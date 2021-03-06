# Convert section 7 coords to NAD83, dec. deg.
# Copyright (c) 2016 Defenders of Wildlife, jmalcom@defenders.org

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
# 

library(rgdal)
library(sp)

load("FWS_S7_clean_03May2016_0-2.RData")

names(full)
dim(full)

convert_dd <- function(x, y, indatum) {
    df <- data.frame(lon = x, lat = y)
    coordinates(df) <- c(1,2)
    proj4string(df) <- CRS(paste0("+proj=longlat +datum=", indatum))
    res <- spTransform(df, CRS("+proj=longlat +datum=NAD83"))
    return(data.frame(res@coords))
}

# Now for the DMS to dec deg conversion
dms2dd <- function(d, m, s, neg=FALSE) {
    if(neg == FALSE) {
        return(d + (m / 60) + (s / 3600))
    } else {
        return(d - (m / 60) - (s / 3600))
    }
}

convert_utm <- function(E, N, zone, datum) {
    df <- data.frame(N=N, E=E, zone=zone, datum=datum)
    res <- data.frame(lon = vector(), lat = vector())
    for(i in unique(df$zone)) {
        sub <- df[df$zone == i, ]
        utm <- SpatialPoints(sub[, 1:2], 
                             proj4string=CRS(paste0("+proj=utm +lon112w +zone=", 
                                                    i, 
                                                    " +datum=NAD27")))
        tmp <- spTransform(utm, CRS("+proj=longlat +datum=NAD83"))
        res <- rbind(res, tmp@coords)
    }
    names(res) <- c("lon", "lat")
    return(res)
}

##################################
# Now for all of the NAD27 samples
nad27 <- full[full$datum == "NAD27" & !is.na(full$datum) & full$datum != "", ]
nad27_dd <- nad27[!is.na(nad27$lat_dec_deg), ]
nad27_dms <- nad27[!is.na(nad27$lat_deg), ]
nad27_utm <- nad27[!is.na(nad27$UTM_E), ]
dim(nad27_dd)
dim(nad27_dms)
dim(nad27_utm)

nad27_dd_nad83dd <- convert_dd(nad27_dd[,27], nad27_dd[,26], "NAD27")
nad27_dd$nad83_lon <- nad27_dd_nad83dd[,1]
nad27_dd$nad83_lat <- nad27_dd_nad83dd[,2]

nad27dms_dec_lat <- dms2dd(nad27_dms[, 28], nad27_dms[, 29], nad27_dms[, 30])
nad27dms_dec_lon <- dms2dd(nad27_dms[, 31], nad27_dms[, 32], nad27_dms[, 33], neg=TRUE)
nad27_dms_nad83dd <- convert_dd(nad27dms_dec_lon, nad27dms_dec_lat, "NAD27")
nad27_dms$nad83_lon <- nad27_dms_nad83dd[,1]
nad27_dms$nad83_lat <- nad27_dms_nad83dd[,2]

nad27_utm_nad83dd <- convert_utm(nad27_utm[, 34], nad27_utm[, 35],
                                 nad27_utm[, 36], "NAD27")
nad27_utm$nad83_lon <- nad27_utm_nad83dd[,1]
nad27_utm$nad83_lat <- nad27_utm_nad83dd[,2]

nad27_nad83 <- rbind(nad27_dd, nad27_dms, nad27_utm)

##################################
# Now for all of the NAD83 samples
nad83 <- full[full$datum == "NAD83" & !is.na(full$datum) & full$datum != "", ]
nad83_dd <- nad83[!is.na(nad83$lat_dec_deg), ]
nad83_dms <- nad83[!is.na(nad83$lat_deg), ]
nad83_utm <- nad83[!is.na(nad83$UTM_E), ]
dim(nad83)
dim(nad83_dd)
dim(nad83_dms)
dim(nad83_utm)

nad83_dd_nad83dd <- convert_dd(nad83_dd[,27], nad83_dd[,26], "NAD83")
nad83_dd$nad83_lon <- nad83_dd_nad83dd[,1]
nad83_dd$nad83_lat <- nad83_dd_nad83dd[,2]

nad83dms_dec_lat <- dms2dd(nad83_dms[, 28], nad83_dms[, 29], nad83_dms[, 30])
nad83dms_dec_lon <- dms2dd(nad83_dms[, 31], nad83_dms[, 32], nad83_dms[, 33], neg=TRUE)
nad83_dms_nad83dd <- convert_dd(nad83dms_dec_lon, nad83dms_dec_lat, "NAD83")
nad83_dms$nad83_lon <- nad83_dms_nad83dd[,1]
nad83_dms$nad83_lat <- nad83_dms_nad83dd[,2]

nad83_utm_nad83dd <- convert_utm(nad83_utm[, 34], nad83_utm[, 35],
                                 nad83_utm[, 36], "NAD83")
nad83_utm$nad83_lon <- nad83_utm_nad83dd[,1]
nad83_utm$nad83_lat <- nad83_utm_nad83dd[,2]

nad83_nad83 <- rbind(nad83_dd, nad83_dms, nad83_utm)


##################################
# Now for all of the WGS84 samples
wgs84 <- full[full$datum == "WGS84" & !is.na(full$datum) & full$datum != "", ]
wgs84_dd <- wgs84[!is.na(wgs84$lat_dec_deg), ]
wgs84_dms <- wgs84[!is.na(wgs84$lat_deg), ]
wgs84_utm <- wgs84[!is.na(wgs84$UTM_E), ]
dim(wgs84)
dim(wgs84_dd)
dim(wgs84_dms)
dim(wgs84_utm)

wgs84_dd_nad83dd <- convert_dd(wgs84_dd[,27], wgs84_dd[,26], "WGS84")
wgs84_dd$nad83_lon <- wgs84_dd_nad83dd[,1]
wgs84_dd$nad83_lat <- wgs84_dd_nad83dd[,2]

wgs84dms_dec_lat <- dms2dd(wgs84_dms[, 28], wgs84_dms[, 29], wgs84_dms[, 30])
wgs84dms_dec_lon <- dms2dd(wgs84_dms[, 31], wgs84_dms[, 32], wgs84_dms[, 33], neg=TRUE)
wgs84_dms_nad83dd <- convert_dd(wgs84dms_dec_lon, wgs84dms_dec_lat, "WGS84")
wgs84_dms$nad83_lon <- wgs84_dms_nad83dd[,1]
wgs84_dms$nad83_lat <- wgs84_dms_nad83dd[,2]

wgs84_utm_nad83dd <- convert_utm(wgs84_utm[, 34], wgs84_utm[, 35],
                                 wgs84_utm[, 36], "WGS84")
wgs84_utm$nad83_lon <- wgs84_utm_nad83dd[,1]
wgs84_utm$nad83_lat <- wgs84_utm_nad83dd[,2]

wgs84_nad83 <- rbind(wgs84_dd, wgs84_dms, wgs84_utm)

##################################
# And combined the data
with_coord <- rbind(nad27_nad83, nad83_nad83, wgs84_nad83)

no_coord <- full[is.na(full$datum) | full$datum == "", ]
dim(no_coord)

no_coord$nad83_lon <- rep(NA, length(no_coord[,1]))
no_coord$nad83_lat <- rep(NA, length(no_coord[,1]))
dim(no_coord)

names(with_coord) == names(no_coord)

semi <- rbind(with_coord, no_coord)
names(semi)

fin <- semi[, c(1:24, 37:51)]
fin$datum <- rep("NAD83", length(fin$nad83_lon))
names(fin)[38:39] <- c("long", "lat")
names(fin)

full <- fin
save(full, file="FWS_S7_clean_03May2016_0-3.RData")


