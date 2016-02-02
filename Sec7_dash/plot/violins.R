# Violin plot templates for Shiny apps.
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

#############################################################################
# Violin plot templates for Shiny apps.
#
# A set of templates for returning violin plots of several basic styles. The 
# templates generally include both a two-plot version--for side-by-side
# presentation--and a single-plot version. Try to use these templates before
# making a new plotting function, recognizing that some customizations may 
# require writing a new function. If a new function is needed, it may be best
# to copy the closest existing template and then modify.
# 
# One of several graphics packages (e.g., ggplot, rCharts, ggvis, etc.) should 
# be used in a single app for consistency of appearance. This suggestion should
# not be construed as a hard-and-fast rule, however: there may be cases in
# which different packages offer the best presentation of different types of
# data. In such cases, styling elements of different pacakages should be 
# homogenized as best as possible to improve consistency.
# 
#############################################################################

