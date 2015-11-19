# load the data with shiny::runApp()
states <- table(full$state)
st_df <- data.frame(state=names(states),
                    consults=as.vector(states))

t <- gvisGeoChart(st_df, 
                  locationvar="state", 
                  colorvar="consults", 
                  options=list(width=1000, 
                               height=642, 
                               region="US", 
                               displayMode="regions", 
                               resolution="provinces", 
                               colorAxis="{colors:['#D2E5C9', '#166827']}", 
                               datalessRegionColor="#FFFFFF", 
                               projection="lambert")
     )

plot(t)
