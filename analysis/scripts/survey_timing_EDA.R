############
# Basic data visualization of survey timing (from species_data object),
# ultimately leading to further filtering of that object for later analyses.
########
# Libraries used: ggplot2,
########
# Joel Reynolds (repurposing code by Madeleine Ward)
# Last Edit: 2019 Apr 27
########

## Display the dates surveys were conducted across each year

plot_alldates <- species_data %>%
  ggplot(aes(YearDay,Year)) +
  geom_point(col="black", size=1.5) +   # Draw points
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May,
       ... and Oct in non-leap years)")

## Display sightings for each species collapsed across sites for given survey date

plot_phenology <- ggplot() +
  #add layer for all possible survey dates
  geom_point(data = species_data %>%
               distinct(Date, .keep_all = TRUE) %>%
               select(Date, Year, YearDay),
             #plot with open circle shape & greater transparency
             aes(x = YearDay, y = Year), shape = 1, alpha = .5) +
  #add layer for species-specific sighting dates, closed circles
  geom_point(data = target_data,
             aes(x = YearDay, y = Year)) +
  #titles and Julian date markers
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="darkgrey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May,
       ... and Oct in non-leap years)",
       title= "Survey Success for Target Species") +
  #temp; make background white for clearer contrast
  theme_bw() +
  #facet by target species; common name used
  facet_wrap(~Common_Name)


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

