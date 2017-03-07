# A quick script to get Sec7 data for MO.
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


load("~/Dropbox/Defenders/data/ESA_consultations/RDATAs/FWS_consults_08-14_final_byConsult.RData")
full <- by_consult

sub <- subset(full, full$ESOffice == "COLUMBIA ECOLOGICAL SERVICES FIELD OFFICE")
dim(sub)

missing <- subset(sub, sub$formal=="Yes" & (sub$n_NLAA==0 & sub$n_conc==0 & sub$n_tech==0))
dim(missing)

# missing <- subset(full, full$formal=="Yes" & (full$n_NLAA==0 & full$n_conc==0 & full$n_tech==0))
# dim(missing)
