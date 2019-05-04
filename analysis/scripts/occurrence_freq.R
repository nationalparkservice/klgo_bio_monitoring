############
# Create a graphic of species frequency of occurrence.
########
# Libraries used: dplyr, ggplot2,
########
# Madeleine Ward
# Last Edit: 2019 Apr 16
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
#each year
occurrence_species2 <- target_data %>%
  group_by(Year) %>%
  mutate(all_obs = sum(obs_date)) %>%
  ungroup() %>%
  #find percent of observations accreditable to each species
  group_by(Species, Year) %>%
  mutate(percent_obs = obs_date/all_obs)

occurrence_species$Common_Name <- reorder(occurrence_species$Common_Name, -occurrence_species$percent_obs)

plot_occurrence <- ggplot(occurrence_species, aes(YearDay, percent_obs)) +
  geom_point(alpha = .1) +
  geom_line(alpha = .02) +
  theme_bw() +
  facet_wrap(~Common_Name, nrow = 5)
plot_occurrence
