############
# Basic data visualization of survey timing (from species_data object),
# ultimately leading to further filtering of that object for later analyses.
########
# Libraries used: ggplot2,
########
# Joel Reynolds (repurposing code by Madeleine Ward)
# Last Edit: 2019 Mar 17
########

# Display the dates surveys were conducted across each year
plot_surveydates <- species_data %>%
  ggplot(aes(YearDay,Year)) +
  geom_point(col="black", size=1.5) +   # Draw points
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)") +
  theme_bw()

#UNFINISHED
all_dates <- species_data %>%
  select(Date) %>%
  unique() %>%
  mutate(all_date = 1)

all_targets <- target_data %>%
  mutate(sighting_date = ifelse(Date %in% all_dates$Date, 1, 0))

target_dates <- full_join(all_dates, all_targets, by = "Date")

full_join(all_dates, by = "Date")

#### STILL TO FINISH
# figure out which dates observed any of the key species - maybe facet on each?
# then plot an open circle over that survey date (so we see which surveys were bust)
# build toward species specific phenology plots.


Plot2<- ggplot(target_dates, aes(YearDay, Year)) +
  geom_point(shape = 21)

Plot3 <- Plot2 +
  geom_point(aes(shape = as.factor(is_sighted))) +
  facet_wrap(~Common_Name)

geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
           linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)")+
  scale_shape_manual(values = c(16, 21)) +
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

