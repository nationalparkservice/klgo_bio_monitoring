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
  geom_point(col="black", size=1.5) +   # Draw points
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)") +
  theme_bw()

species_target_data <- species_data %>%
  mutate(is_target = ifelse(Common_Name %in% target_data$Common_Name, 1, 0))

#### STILL TO FINISH
  # figure out which dates observed any of the key species - maybe facet on each?
  # then plot an open circle over that survey date (so we see which surveys were bust)
  # build toward species specific phenology plots.
Plot2<- species_target_data %>%
  ggplot(aes(YearDay,Year)) +
  geom_point(col="black", size=1.5, aes(shape = as.factor(is_target))) +   # Draw points
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)")+
  scale_shape_manual(values = c(16, 21)) +
  theme_bw() +
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


