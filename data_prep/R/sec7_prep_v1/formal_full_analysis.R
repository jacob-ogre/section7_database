# formal_full_analyses.R
# Just what the name says.
# Copyright (C) 2014 Jacob Malcom, jacob.w.malcom@gmail.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

###############################################################################
# Imports
###############################################################################
require("lubridate")

###############################################################################
# Functions
###############################################################################


###############################################################################
# Load the data
###############################################################################
# Re-save the data 
load("formal_2008-2014_cleaned.RData")
dim(dat)
names(dat)

sort(table(dat$Species.Involved...Evaluated))

tort <- subset(dat, 
               dat$Species.Involved...Evaluated=="Gopher tortoise (Gopherus polyphemus)")
dim(tort)

CAGN <- subset(dat, 
               dat$Species.Involved...Evaluated=="Coastal California gnatcatcher (Polioptila californica californica)")
dim(CAGN)

CAGN <- subset(dat, 
               dat$Species.Involved...Evaluated=="Coastal California gnatcatcher (Polioptila californica californica)")
dim(CAGN)
