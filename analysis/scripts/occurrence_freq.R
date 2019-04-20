############
# Create a graphic of species frequency of occurrence.
########
# Libraries used: dplyr, ggplot2,
########
# Madeleine Ward
# Last Edit: 2019 Apr 16
########

all_surveys <- species_data %>%
  select(Date, Year, Month, Day, YearDay, Duration) %>%
  distinct(Date
           #, .keep_all = TRUE
           )

occurrence_data <- target_data %>%
  filter(Species == "MEGU")
left_join(all_surveys, occurrence_data, by = "Date")
#%>%
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
  coord_flip() +
  facet_wrap(~Common_Name)


occurrence_species2 <- target_data %>%
  group_by(Year) %>%
  mutate(all_obs = sum(obs_date)) %>%
  ungroup() %>%
  #find percent of observations accreditable to each species
  group_by(Species, Year) %>%
  mutate(percent_obs = obs_date/all_obs)
  