############
# Basic data visualization of survey timing (from species_data object),
# ultimately leading to further filtering of that object for later analyses.
########
# Libraries used: ggplot2,
########
# Joel Reynolds (repurposing code by Madeleine Ward)
# Last Edit: 2019 Feb 8
########

# Display the dates surveys were conducted across each year
Plot1<- species_data %>%
  ggplot(aes(YearDay,Year)) +
  geom_point(col="blue", size=2) +   # Draw points
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)")


#### STILL TO FINISH (then remove "if (0) {","}")
if (0) {
  # figure out which dates observed any of the key species - maybe facet on each?
  # then plot an open circle over that survey date (so we see which surveys were bust)
  # build toward species specific phenology plots.
  species_data %>%
    ggplot(aes(YearDay,Year)) +
    geom_point(col="blue", size=2) +   # Draw points
    geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
               linetype=2, colour="grey") +
    labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)")
  # add new aes & geom_point to plot open circle on just those dates that species X was seen
  # geom_point....
}


####### Ideas to pursue later
#######

# another view showing frequency across years
# first need to collapse across species, locations, etc....
if (0) {
  species_data %>%
    ggplot(aes(YearDay)) +
    geom_dotplot(col="blue") +   # Draw points
    geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
               linetype=2, colour="grey") +
    labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)")

}


