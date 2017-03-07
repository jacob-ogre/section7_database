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
# Create a small dataframe for top 10 species bar plot
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
# Create a small dataframe for top 10 agencies bar plot
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

baseout <- "~/Google Drive/Defenders/JWM_reports/semi-finals/section_7_consultation/"
pdf(file=paste(baseout, "for_brief_2.pdf", sep=""),
    height=2.45,
    width=5.35)
allFig
dev.off()

############################################################################
# Want to see agencies by pct formal
all_by_agency <- table(full$lead_agency)
high_consult_agencies <- names(all_by_agency[all_by_agency > 159])
all_form <- full[full$formal_consult == "Yes" & !is.na(full$formal_consult), ]
form_by_agency <- table(all_form$lead_agency)
pct_form_by_agency <- form_by_agency / all_by_agency
head(sort(pct_form_by_agency, decreasing=TRUE), 50)
high_pct_form_agency <- pct_form_by_agency[names(pct_form_by_agency) %in% high_consult_agencies]
head(sort(high_pct_form_agency, decreasing=TRUE), 42)

############################################################################
# BLM analysis
foc_agency <- "Bureau of Land Management"
cur_dat <- full[full$lead_agency == foc_agency & !is.na(full$lead_agency), ]
cur_form <- cur_dat[cur_dat$formal_consult == "Yes" & 
                    !is.na(cur_dat$formal_consult), ]
cur_inform <- cur_dat[cur_dat$formal_consult == "No" & 
                      !is.na(cur_dat$formal_consult), ]

cur_program <- cur_dat[cur_dat$consult_complex == "Programmatic Program-Level" & 
                       !is.na(cur_dat$consult_complex), ]
cur_project <- cur_dat[cur_dat$consult_complex == "Programmatic Project-Level" & 
                       !is.na(cur_dat$consult_complex), ]
cur_progs <- rbind(cur_program, cur_project)

cur_dat$formal_consult <- relevel(as.factor(cur_dat$formal_consult), ref="No")

n_all <- dim(cur_dat)
n_form <- dim(cur_form)
n_inform <- n_all - n_form
n_all
n_form
n_inform
n_inform / n_all

cur_by_FY <- table(cur_dat$FY)
form_by_FY <- table(cur_form$FY)
plot(form_by_FY / cur_by_FY)
plot(table(cur_program$FY))
plot(table(cur_project$FY))

work_cats <- table(cur_dat$work_cat)
work_cats <- sort(work_cats, decreasing=TRUE)
cat_df <- data.frame(work_cat=names(work_cats),
                     n_consult=as.vector(work_cats),
                     cumsum=cumsum(as.vector(work_cats)))
plot(cat_df$cumsum, ylim=c(0, 1800))

median(cur_inform$elapsed, na.rm=TRUE)
dim(cur_inform[cur_inform$elapsed < 30 & !is.na(cur_inform$elapsed),])
median(cur_form$elapsed, na.rm=TRUE)
dim(cur_form[cur_form$elapsed < 135 & !is.na(cur_form$elapsed),])
median(cur_program[cur_program$formal_consult=="Yes",]$elapsed, na.rm=TRUE)
median(cur_project[cur_project$formal_consult=="Yes",]$elapsed, na.rm=TRUE)
dim(cur_form[cur_form$elapsed < 135 & !is.na(cur_form$elapsed),])

##############
# BLM by FY plot
blmFig <- ggplot(data=cur_dat, aes(factor(FY), fill=formal_consult)) +
          geom_bar(data=cur_dat, aes(order=desc(formal_consult)), alpha=0.7) + 
          scale_fill_manual(values=c('#0A4783', "#f49831"),
                            labels=c("informal", "formal"),
                            name="") +
          labs(x="Fiscal Year",
               y="# consultations") +
          geom_hline(yintercept=round(seq(50, 300, 50)), 
                     col="white", lwd=1) +
          theme_tufte(base_size=14, ticks=FALSE) +
          theme(axis.text.x=element_text(angle=30, vjust=1.5, hjust=1),
                text=element_text(size=14, family="Open Sans"),
                legend.position="top",
                legend.direction="horizontal")
blmFig

baseout <- "~/Google Drive/Defenders/JWM_reports/semi-finals/BLM_sec7/"
pdf(file=paste(baseout, "BLM_by_FY.pdf", sep=""),
    height=2.5,
    width=5.5)
blmFig
dev.off()

##############
# BLM by work_cat plot
work_dat <- make_top_10_work_cat_df(cur_dat)
blmWorkFig <- ggplot(data=work_dat,
                     aes(x=position, 
                         y=consultations,
                         width=0.5)) +
              geom_bar(stat="identity", alpha=0.5) +
              geom_hline(yintercept=round(seq(25,300, 25)),
                         col="white", lwd=1) +
              coord_flip() +
              labs(x="", y="\n# Consultations") +
              theme_tufte(base_size=14, ticks=FALSE) +
              theme(text=element_text(size=12, family="Open Sans"),
                    axis.text.x=element_text(size=11),
                    axis.text.y=element_text(size=8))
blmWorkFig


baseout <- "~/Google Drive/Defenders/JWM_reports/semi-finals/BLM_sec7/"
pdf(file=paste(baseout, "BLM_by_work_cat", sep=""),
    height=3.5,
    width=5.5)
blmWorkFig
dev.off()





