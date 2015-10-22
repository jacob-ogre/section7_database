base <- "~/Repos/defenders_sec7_shiny/data/"
infile <- paste(base, "sec7_updated_names_30Jul2015.tab", sep="")
to_save <- paste(base, "FWS_S7_clean_30Jul2015.RData", sep="")
full <- read.table(infile,
                   sep="\t",
                   header=TRUE,
                   stringsAsFactors=FALSE)

dim(full)
names(full)

spp_list <- strsplit(full$spp_ev_ls, split="; ")
full$spp_ev_ls <- spp_list
full$work_category <- as.factor(full$work_category)


save(full, file=to_save)

