#
#

# The data sets
taxa <- c("Amph", "Arach", "Bird", "Clam", "Conif", "Coral", "Crust", "Fern",
          "Fish", "Plant", "Insect", "Lichen", "Mamm", "Rept", "Snail")
pct_consult <- c(2.0, 0.3, 26.4, 10.0, 0.1, 0.003, 0.9, 0.7, 10.3, 12.8, 2.8, 0.06,
                 21.3, 11.7, 0.5)
pct_list <- c(2.3, 0.7, 7.3, 5.5, 0.3, 0.1, 2.5, 2.0, 9.4, 47.4, 5.6, 0.1, 6.3,
              3.1, 7.3)
dat <- data.frame(taxa=taxa, pct_cons=pct_consult, pct_list=pct_list)
dat$ratio <- dat$pct_cons / dat$pct_list

plot(pct_consult ~ pct_list, data=dat,
     xlab="% of listed species",
     ylab="% of consultations with group")

pdf(file="~/infograph_2_pctList_pctConsult.pdf", height=10, width=10)
ac <- ggplot(data=dat, aes(x=pct_list, y=pct_cons+0.001)) +
      geom_point(size=3, alpha=0.2) +
      geom_text(aes(label=taxa), hjust=0, vjust=0, size=3, colour="gray63") +
      scale_x_continuous(name="% of listed species", 
                         limits=c(0.001, 50),
                         trans="sqrt") +
      scale_y_continuous(name="% of consultations with group", 
                         limits=c(0.001, 50),
                         trans="sqrt") +
      geom_abline(intercept=0.001, slope=1) +
      theme_minimal() 
ac
dev.off()

ac <- ggplot(data=dat, aes(x=pct_list, y=ratio+0.001)) +
      geom_point(size=3, alpha=0.2) +
      scale_x_log10(name="% of listed species") +
      scale_y_continuous(name="% of consultations with group",
                         trans="sqrt") +
      theme_minimal() 
ac

ac <- ggplot(data=dat, aes(x=pct_list, y=ratio)) +
      geom_point(size=3, alpha=0.8) +
      geom_text(aes(label=taxa), hjust=0, vjust=0, size=3, colour="gray63") +
      scale_x_log10(name="% of listed species") +
      scale_y_continuous(name="Likelihood of representation",
                         trans="sqrt") +
      theme_minimal() 
ac

pdf(file="~/infograph_2_pctList_overRepresentation.pdf", height=10, width=10)
ac <- ggplot(data=dat, aes(x=pct_list, y=ratio)) +
      geom_point(size=3, alpha=0.8) +
      geom_text(aes(label=taxa), hjust=0, vjust=0, size=3, colour="gray63") +
      scale_x_continuous(name="% of listed species",
                         trans="sqrt") +
      scale_y_continuous(name="Likelihood of representation",
                         trans="sqrt") +
      theme_minimal() 
ac
dev.off()
