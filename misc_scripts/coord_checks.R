# A quick script to pull select records for which the coordinates are odd.

quest <-  c("43440-2010-I-0201", "43440-2010-I-0955", "43910-2009-I-0150",
            "31131-2009-I-0092", "52420-2008-I-0992", "52420-2009-I-0180",
            "52420-2009-I-0102", "51410-2009-I-0411", "52420-2008-I-0375",
            "52420-2008-I-0279", "81420-2009-F-0209", "61411-2009-F-0337",
            "52420-2010-I-0373", "52421-2009-I-0381", "52421-2009-I-0381",
            "81420-2011-F-0631", "43421-2010-I-0150", "08ESMF00-2012-F-0671",
            "43421-2010-I-0120", "41460-2008-I-0795", "51411-2009-I-0686",
            "81440-2010-I-0336", "43410-2010-IE-0619", "43440-2010-I-1242",
            "41420-2010-I-0346", "41420-2010-I-0346", "41430-2009-I-0086",
            "81420-2008-F-1178", "13420-2009-I-0131")

subs <- full[full$activity_code %in% quest, ]
dim(subs)
head(subs)

make_writeable <- function(x) {
    a_copy <- x
    a_copy$spp_ev_ls <- unlist(lapply(a_copy$spp_ev_ls, FUN=paste, collapse="; "))
    a_copy$spp_BO_ls <- unlist(lapply(a_copy$spp_BO_ls, FUN=paste, collapse="| "))
    spp_ev_ls <- gsub(pattern="\n", replace="", a_copy$spp_ev_ls)
    spp_BO_ls <- gsub(pattern="\n", replace="", a_copy$spp_BO_ls)
    a_copy$spp_ev_ls <- spp_ev_ls
    a_copy$spp_BO_ls <- spp_BO_ls
    return(a_copy)
}

w <- make_writeable(subs)

basics <- data.frame(id=w$activity_code,
                     region=w$region,
                     state=w$state,
                     ESO=w$ESOffice,
                     title=w$title,
                     agency=w$lead_agency,
                     start=w$start_date,
                     spp_ev=w$spp_ev_ls,
                     spp_BO=w$spp_BO_ls)

write.table(basics,
            file="~/Google Drive/Defenders/EndSpCons_shared/mapping/sec7_consults/anomaly_detail_data.tab",
            sep="\t",
            quote=FALSE,
            row.names=FALSE)

