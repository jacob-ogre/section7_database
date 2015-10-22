# Preparing data after splitting up the determination call.
# Copyright (C) 2015 Defenders of Wildlife

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


dat <- read.table("~/Dropbox/Defenders_data/FWS_consultations_2008-2014_byProj_expand.tab",
    sep="\t",
    header=TRUE)

# Convert to useful types...
to_factor <- c(1:10, 15:18, 21, 24:42, 44:46)
for(i in to_factor) {
    dat[,i] <- as.factor(dat[,i])
}

to_date <- c(11:13, 20)
for(i in to_date) {
    dat[,i] <- as.Date(dat[,i])
}

elapsed <- as.numeric(dat$date_active_concl - dat$start_date)
dat <- data.frame(dat, elapsed)
dat <- subset(dat, elapsed >= 0)
dim(dat)

save(dat, file="~/Dropbox/Defenders_data/FWS_consult_08-14_semifinal.RData")

