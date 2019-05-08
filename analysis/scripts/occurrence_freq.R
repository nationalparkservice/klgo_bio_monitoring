############
# Create graphics of species frequency of occurrence by year and date.
########
# Libraries used: dplyr, ggplot2
########
# Madeleine Ward
# Last Edit: 2019 May 8
########

# graph shows observations each year relative to other TARGET species
#percent_obs will be the percent of observations each date that 
#the spp composed
occurrence_species <- target_data %>%
  group_by(Year, YearDay) %>%
  
  #find all observations of all species on certain date
  mutate(all_obs = sum(obs_date)) %>%
  ungroup() %>%
  
  #find percent of observations accreditable to each species
  group_by(Year, YearDay, Species) %>%
  mutate(percent_obs = obs_date/all_obs) %>%
  ungroup() 

#attempt to reorder facets by total percent of observations
#occurrence_species$Common_Name <- reorder(occurrence_species$Common_Name, 
#                                          occurrence_species$percent_obs)
## doesn't work?

#plot of observation frequency
plot_occurrenceDay <- ggplot(occurrence_species, aes(YearDay, percent_obs)) +
  #set alpha so clustered points visible
  geom_point(alpha = .1) +
  #geom_line(aes(color = as.factor(Year))) +
  labs(title = "Species Occurrence by Date",
       x= "Julian Date \n (vertical lines denote 1st of April, May, ... 
       and Oct in non-leap years)",
       y = "Percent of All Observations Species Composed") + 
  #geom_line(alpha = .08) +
  #set background to white for clarity
  theme_bw() +
  facet_wrap(~Common_Name, ncol = 4)

##...each year
occurrence_species2 <- target_data %>%
  filter(!is.na(obs_date)) %>%
  group_by(Year) %>%
  mutate(all_obs = sum(obs_date)) %>%
  ungroup() %>%
  
  #find percent of observations accreditable to each species
  group_by(Year, Species) %>%
  mutate(percent_obs = sum(obs_date)/all_obs) %>%
  slice(1)

#plot of observation frequency by Year
plot_occurrenceYear <- ggplot(occurrence_species2, aes(Year, percent_obs)) +
  #set alpha so clustered points visible
  geom_bar(stat = "identity") + 
  #geom_point(alpha = .1) +
  labs(title = "Species Occurrence by Year",
       y = "Percent of All Observations Species Composed") + 
  coord_flip() +
  #geom_line(alpha = .08) +
  #set background to white for clarity
  theme_bw() +
  facet_wrap(~Common_Name, ncol = 3)

## TO DO: how to order facets by freq and/or delete Spp that aren't useful?
