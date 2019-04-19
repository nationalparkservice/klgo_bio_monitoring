############
# Create a graphic of species frequency of occurrence.
########
# Libraries used: dplyr, ggplot2,
########
# Madeleine Ward
# Last Edit: 2019 Apr 16
########


occurrence_data <- target_data %>%
  group_by(Year) #%>%
  #mutate()

#second graph shows observations each year relative to other species
#percent_obs will be the percent of observations each date that 
#the spp composed
occurrence_species <- target_data %>%
  group_by(Year, YearDay) %>%
  #find all observations of all species on certain date
  mutate(all_obs = sum(obs_date)) %>%
  ungroup() %>%
  #find percent of observations accreditable to each species
  group_by(Species, Year, YearDay) %>%
  mutate(percent_obs = obs_date/all_obs) #%>%
  #filter(Species == "HERG")

ggplot(occurrence_species, aes(Year, percent_obs)) +
  geom_boxplot(aes(group = Year)) +
  #for now, limit set at 50% - how to account for variability?
  scale_y_continuous(limits = c(0, .50)) +
  facet_wrap(~Species)
