# Make plots with ggplot2 for the section 7 ms.
# Copyright © 2015 Defenders of Wildlife, jmalcom@defenders.org

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

library(extrafont)
library(ggplot2)
library(ggthemes)
library(stringr)

#############################################################################
# Data is loaded into memory by launching the basic_alt app, then the following
# code is executed (through tmux) 

#############################################################################
# Functions

##############################################################################
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
##############################################################################
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
    require(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel
        # ncol: Number of columns of plots
        # nrow: Number of rows needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                         ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
        print(plots[[1]])
        
    } else {
        # Set up the page
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        
        # Make each plot, in the correct location
        for (i in 1:numPlots) {
            # Get the i,j matrix positions of the regions that contain subplot
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                            layout.pos.col = matchidx$col))
        }
    }
}

############################################################################
# Create a small dataframe for top 25 species bar plot
make_top_10_species_df <- function(sub) {
    sub_species <- table(unlist(sub$spp_ev_ls))
    sorted <- -sort(-sub_species)
    if (length(sorted) <= 10) {
        dat <- data.frame(species=names(sorted), 
                          consultations=as.vector(sorted))
    } else {
        dat <- data.frame(species=names(sorted)[1:10], 
                          consultations=as.vector(sorted[1:10]))
    }
    dat <- dat[order(dat$consultations, decreasing=FALSE),]
    dat$position <- factor(seq(1, length(dat$species), 1),
                           labels=str_wrap(dat$species, 30))
    return(dat)
}

############################################################################
# Create a small dataframe for top 25 agencies bar plot
make_top_10_agencies_df <- function(sub) {
    sub_agency <- table(sub$lead_agency)
    sorted <- -sort(-sub_agency)
    sorted <- sorted[sorted > 0]
    if (length(sorted) <= 10) {
        dat <- data.frame(agency=names(sorted), 
                          consultations=as.vector(sorted))
    } else {
        dat <- data.frame(agency=names(sorted)[1:10], 
                          consultations=as.vector(sorted[1:10]))
    }
    dat <- dat[order(dat$consultations, decreasing=FALSE),]
    dat$position <- factor(seq(1, length(dat$agency), 1),
                           labels=str_wrap(dat$agency, 30))
    return(dat)
}

############################################################################
# Create a small dataframe for state work categories summary figure
make_top_10_work_cat_df <- function(x) {
    categories <- table(droplevels(x$work_category))
    sorted <- -sort(-categories)
    if (length(sorted) <= 10) {
        dat <- data.frame(work_cat=names(sorted), 
                          consultations=as.vector(sorted))
    } else {
        dat <- data.frame(work_cat=names(sorted)[1:10], 
                          consultations=as.vector(sorted[1:10]))
    }
    dat <- dat[order(dat$consultations, decreasing=FALSE),]
    dat$position <- factor(seq(1, length(dat$work_cat), 1),
                           labels=str_wrap(dat$work_cat, 30))
    return(dat)
}


#############################################################################
# Now for the plots
#############################################################################
# Figure 1
#
# Some data subsets
formals <- full[full$formal_consult == "Yes" & !is.na(full$formal_consult),]

ND <- full[full$ESOffice == "NORTH DAKOTA ECOLOGICAL SERVICES FIELD OFFICE" &
           !is.na(full$ESOffice), ]
NDformal <- ND[ND$formal_consult == "Yes" & !is.na(ND$formal_consult),]

# The figure itself
allFig <- ggplot(data=full, aes(factor(FY))) +
          geom_bar(data=full, alpha=0.5) + 
          geom_bar(data=formals, alpha=1) + 
          geom_hline(yintercept=round(seq(2500, 15000, 2500)), 
                     col="white", lwd=1) +
          labs(x="",
               y="# consultations") +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(axis.text.x=element_text(angle=30, vjust=1.5, hjust=1),
                text=element_text(size=14, family="Open Sans"))
allFig

tab <- table(ND$FY)
NDFig <- ggplot(data=ND, aes(factor(FY))) +
         geom_bar(data=ND, alpha=0.5) + 
         geom_bar(data=NDformal, alpha=1) + 
         geom_hline(yintercept=round(seq(50, 400, 50)), 
                    col="white", lwd=1) +
         labs(x="",
              y="") +
         theme_tufte(base_size=14, ticks=FALSE) +
         theme(axis.text.x=element_text(angle=30, vjust=1.5, hjust=1),
               text=element_text(size=14, family="Open Sans"))
NDFig

multiplot(allFig, NDFig, cols=2)

baseout <- "~/Google Drive/Defenders/JWM_reports/drafts/Sec7/ms/"
cur_out <- paste(baseout, "sec7_Fig1_v1.pdf", sep="")

pdf(file=cur_out, height=4, width=8, family="Open Sans")
multiplot(allFig, NDFig, cols=2)
dev.off()

#############################################################################
# Figure 2
spp_dat <- make_top_10_species_df(full)
agency_dat <- make_top_10_agencies_df(full)
work_dat <- make_top_10_work_cat_df(full)

sppFig <- ggplot(data=spp_dat,
                 aes(x=position, 
                     y=consultations,
                     width=0.5)) +
          geom_bar(stat="identity", alpha=0.5) +
          geom_hline(yintercept=round(seq(2500, 15000, 2500)),
                     col="white", lwd=1) +
          coord_flip() +
          labs(x="",
               y="\n",
               title="Species") +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(text=element_text(size=3.5, family="Open Sans"),
                axis.text.x=element_text(size=3.5),
                axis.text.y=element_text(size=3.5))
sppFig

agencyFig <- ggplot(data=agency_dat,
                 aes(x=position, 
                     y=consultations,
                     width=0.5)) +
          geom_bar(stat="identity", alpha=0.5) +
          geom_hline(yintercept=round(seq(2500, 17500, 2500)),
                     col="white", lwd=1) +
          coord_flip() +
          labs(x="",
               y="\n# consultations",
               title="Agencies") +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(text=element_text(size=3.5, family="Open Sans"),
                axis.text.x=element_text(size=3.5),
                axis.text.y=element_text(size=3.5))
agencyFig

workFig <- ggplot(data=work_dat,
                 aes(x=position, 
                     y=consultations,
                     width=0.5)) +
          geom_bar(stat="identity", alpha=0.5) +
          geom_hline(yintercept=round(seq(2500, 12500, 2500)),
                     col="white", lwd=1) +
          coord_flip() +
          labs(x="",
               y="\n",
               title="Work Categories") +
          theme_tufte(base_size=8, ticks=FALSE) +
          theme(text=element_text(size=3.5, family="Open Sans"),
                axis.text.x=element_text(size=3.5),
                axis.text.y=element_text(size=3.5))
workFig

multiplot(sppFig, agencyFig, workFig, cols=1)

baseout <- "/Users/jacobmalcom/Google\ Drive/Defenders/manuscripts/Section_7_db/figures/"
cur_out <- paste(baseout, "sec7_Fig3_v4.pdf", sep="")

pdf(file=cur_out, height=3.42, width=7, family="Open Sans")
multiplot(sppFig, agencyFig, workFig, cols=3)
dev.off()

embed_fonts(cur_out)

#############################################################################
# Figure 2, alt 1
spp_dat <- make_top_10_species_df(full)
agency_dat <- make_top_10_agencies_df(full)
work_dat <- make_top_10_work_cat_df(full)

sppFig <- ggplot(data=spp_dat,
                 aes(x=position, 
                     y=consultations,
                     width=0.5)) +
          geom_bar(stat="identity", alpha=0.5) +
          geom_hline(yintercept=round(seq(2500, 15000, 2500)),
                     col="white", lwd=1) +
          coord_flip() +
          labs(x="Species",
               y="") +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(text=element_text(size=12, family="Open Sans"),
                axis.text.x=element_text(size=11),
                axis.text.y=element_text(size=8))
sppFig

agencyFig <- ggplot(data=agency_dat,
                 aes(x=position, 
                     y=consultations,
                     width=0.5)) +
          geom_bar(stat="identity", alpha=0.5) +
          geom_hline(yintercept=round(seq(2500, 17500, 2500)),
                     col="white", lwd=1) +
          coord_flip() +
          labs(x="Agency",
               y="") +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(text=element_text(size=12, family="Open Sans"),
                axis.text.x=element_text(size=11),
                axis.text.y=element_text(size=8))
agencyFig

workFig <- ggplot(data=work_dat,
                 aes(x=position, 
                     y=consultations,
                     width=0.5)) +
          geom_bar(stat="identity", alpha=0.5) +
          geom_hline(yintercept=round(seq(2500, 12500, 2500)),
                     col="white", lwd=1) +
          coord_flip() +
          labs(x="Work Category",
               y="\n# consultations") +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(text=element_text(size=12, family="Open Sans"),
                axis.text.x=element_text(size=11),
                axis.text.y=element_text(size=8))
workFig

multiplot(sppFig, agencyFig, workFig, cols=3)

baseout <- "~/Google Drive/Defenders/JWM_reports/drafts/Sec7/ms/"
cur_out <- paste(baseout, "sec7_Fig3_v2.pdf", sep="")

pdf(file=cur_out, height=18, width=6, family="Open Sans")
multiplot(sppFig, agencyFig, workFig, cols=1)
dev.off()



#############################################################################
# THe following are simply alternate themes for Fig 1.
#
# Defenders' colors
full$formal_consult <- relevel(as.factor(full$formal_consult), ref="No")

allFig <- ggplot(data=full, aes(factor(FY), fill=formal_consult)) +
          geom_bar(data=full, aes(order=desc(formal_consult)), alpha=0.7) + 
          scale_fill_manual(values=c('#0A4783', "#f49831"),
                            labels=c("informal", "formal"),
                            name="") +
          labs(x="Fiscal Year",
               y="# consultations") +
          geom_hline(yintercept=round(seq(2500, 15000, 2500)), 
                     col="white", lwd=1) +
          labs(x="",
               y="# consultations") +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(axis.text.x=element_text(angle=30, vjust=1.5, hjust=1),
                text=element_text(size=14, family="Open Sans"),
                legend.position="top",
                legend.direction="horizontal")
allFig

baseout <- "~/Google Drive/Defenders/JWM_reports/drafts/Sec7/ms/"
pdf(file=paste(baseout, "for_brief_2.pdf", sep=""),
    height=2.45,
    width=5.35)
allFig
dev.off()

OKFig <- ggplot(data=OK, aes(factor(FY), fill=formal_consult)) +
          geom_bar(data=OK, aes(order=desc(formal_consult)), alpha=0.7) + 
          scale_fill_manual(values=c('#0A4783', "#f49831"),
                            labels=c("informal", "formal"),
                            name="") +
          labs(x="Fiscal Year",
               y="") +
          theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1),
                legend.position="top",
                legend.direction="horizontal")
OKFig

multiplot(allFig, OKFig, cols=2)

# Minimal
allFig <- ggplot(data=full, aes(factor(FY))) +
          geom_bar(data=full, alpha=0.5) + 
          geom_bar(data=formals, alpha=1) + 
          labs(x="Fiscal Year",
               y="# consultations") +
          theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1)) +
          theme_minimal()
allFig

OKFig <- ggplot(data=OK, aes(factor(FY))) +
          geom_bar(data=OK, alpha=0.5) + 
          geom_bar(data=OKformal, alpha=1) + 
          labs(x="Fiscal Year",
               y="") +
          theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1)) +
          theme_minimal()
OKFig

multiplot(allFig, OKFig, cols=2)
# 538
tab <- table(full$FY)
allFig <- ggplot(data=full, aes(factor(FY))) +
          geom_bar(data=full, alpha=0.5) + 
          geom_bar(data=formals, alpha=1) + 
          labs(x="",
               y="# consultations") +
          theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1)) +
          theme_fivethirtyeight(base_size=14) +
          scale_colour_colorblind()
allFig

tab <- table(OK$FY)
OKFig <- ggplot(data=OK, aes(factor(FY))) +
          geom_bar(data=OK, alpha=0.5) + 
          geom_bar(data=OKformal, alpha=1) + 
          labs(x="",
               y="") +
          theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1)) +
          theme_fivethirtyeight(base_size=14) +
          scale_colour_colorblind()
OKFig

multiplot(allFig, OKFig, cols=2)

# Minimal v2
allFig <- ggplot(data=full, aes(factor(FY))) +
          geom_bar(data=full, alpha=0.5) + 
          geom_bar(data=formals, alpha=1) + 
          labs(x="Fiscal Year",
               y="# consultations") +
          theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1),
                axis.ticks.length=unit(0, "cm"),
                axis.title.x=element_text(vjust=0.1),
                panel.background=element_rect(fill="white"))
allFig

OKFig <- ggplot(data=OK, aes(factor(FY))) +
          geom_bar(data=OK, alpha=0.5) + 
          geom_bar(data=OKformal, alpha=1) + 
          labs(x="Fiscal Year",
               y="") +
          theme(axis.text.x=element_text(angle=30, vjust=1, hjust=1),
                axis.title.x=element_text(vjust=0.1),
                axis.ticks.length=unit(0, "cm"),
                panel.background=element_rect(fill="white"))
OKFig

pdf(file="~/Google Drive/Defenders/JWM_reports/drafts/Sec7/ms/basic_FY_plot.pdf",
    height=4,
    width=8)
multiplot(allFig, OKFig, cols=2)
dev.off()

