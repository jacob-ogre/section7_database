test_fx <- function(x) {
    if (is.character(x)) {
        repl <- gsub("),", ");", x, fixed=T)
        split1 <- strsplit(repl, "; ", fixed=T)
        return(split1)
    } else {
        return(x)
    }
}

full$spp_ev_ls <- lapply(full$spp_ev_ls, FUN=test_fx)
save(full, file="data/FWS_S7_clean_15Jun2015.RData")
