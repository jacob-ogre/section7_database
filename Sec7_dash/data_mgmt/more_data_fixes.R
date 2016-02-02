# Finding more problematic TAILS records.
# Copyright (C) 2015 Me
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

# Note that the dataset, "FWS_consults_08-14_forDash.RData", is already loaded

bad_cons <- c("06E21000-2012-F-0149",
              "06E21000-2013-F-0139",
              "06E21000-2013-F-0140",
              "06E21000-2013-F-0500",
              "06E21000-2013-F-0501",
              "06E21000-2013-F-0515",
              "65413-2011-F-0055",
              "65413-2011-I-0102")

bad_con2 <- c("65413-2011-F-0055",
              "65413-2011-I-0102")

nojeop_noadmo <- c( "13260-2008-F-0004",
                    "13260-2008-F-0138",
                    "13260-2009-F-0016",
                    "13260-2009-F-0103",
                    "13260-2009-F-0110",
                    "13260-2009-F-0128",
                    "13260-2009-F-0153",
                    "13260-2011-F-0077",
                    "13260-2011-F-0098",
                    "14420-2010-F-0208",
                    "14421-2009-F-0097",
                    "03E12000-2013-F-0546",
                    "03E12000-2013-F-0547",
                    "33431-2009-F-0012",
                    "04EA1000-2012-F-0350",
                    "65412-2011-F-0644",
                    "71470-2009-F-0209-R001",
                    "80211-2010-F-0007",
                    "08FBDT00-2012-F-0026")

nojeop <- c("04EC1000-2013-F-0325", "01EIFW00-2014-F-0193")

full$spp_BO_ls <- ifelse(full$activity_code %in% bad_cons,
                         gsub("Adverse Modification", "Non-jeopardy", full$spp_BO_ls, fixed=TRUE),
                         full$spp_BO_ls)

full$n_admo <- ifelse(full$activity_code %in% bad_cons,
                      0,
                      full$n_admo)

full$spp_BO_ls <- ifelse(full$activity_code %in% bad_con2,
                         gsub("without", "with", full$spp_BO_ls, fixed=TRUE),
                         full$spp_BO_ls)

full$n_rpa <- ifelse(full$activity_code %in% bad_con2,
                      4,
                      full$n_rpa)

full$n_admo <- ifelse(full$activity_code %in% bad_con2,
                      4,
                      full$n_admo)

full$spp_BO_ls <- ifelse(full$activity_code %in% nojeop_noadmo,
                         gsub("Non-jeopardy / Adverse Mod with RPA",
                              "Non-jeopardy / No Adverse Modification",
                              full$spp_BO_ls, fixed=TRUE),
                         full$spp_BO_ls)

full$spp_BO_ls <- ifelse(full$activity_code %in% nojeop_noadmo,
                         gsub("BO = Adverse Modification",
                              "BO = Non-jeopardy / No Adverse Modification",
                              full$spp_BO_ls, fixed=TRUE),
                         full$spp_BO_ls)

full$spp_BO_ls <- ifelse(full$activity_code %in% nojeop,
                         gsub("Jeopardy with RPA",
                              "Non-jeopardy",
                              full$spp_BO_ls, fixed=TRUE),
                         full$spp_BO_ls)

full$n_rpa <- ifelse(full$activity_code %in% nojeop,
                     0,
                     full$n_rpa)

save(full, file="data/FWS_consults_08-14_forDash.RData")
