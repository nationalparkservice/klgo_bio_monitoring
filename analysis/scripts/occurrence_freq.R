############
# Create graphics of species frequency of occurrence by year and date.
########
# Libraries used: dplyr, ggplot2
########
# Madeleine Ward
# Last Edit: 2019 May 8
########

#percent of surveys, each year, in which species was sighted

#collect total surveys each year
all_surveys_yr <- species_data %>%
  distinct(Event_ID, .keep_all = TRUE) %>%
  group_by(Year) %>%
  summarize(total_surveys = n())

#collect total surveys each year for each species, the percent of sighted surveys
occurrence_species_yr <- target_data %>%
  group_by(Common_Name, Year) %>%
  #all surveys in which Spp were sighted each year
  summarize(species_surveys = n()) %>%
  #join by Year to compare with total
  left_join(all_surveys_yr, by = "Year") %>%
  #calculate percent of yearly surveys in which Spp sighted
  mutate(percent_surveys = species_surveys/total_surveys)

#plot of species occurrence by Year
plot_occurrenceYear <- ggplot(occurrence_species_yr,
                          aes(Year, percent_surveys)) +
  geom_point() +
  #add straight lines
  geom_line() +
  theme_bw() +
  labs(title = "Species Occurence Frequency by Year",
       y = "Percent of Yearly Surveys Observed") +
  facet_wrap(~Common_Name, ncol = 4)

#percent of surveys, each day, in which species was sighted, averaged by year

#collect total surveys each date
all_surveys_date <- species_data %>%
  distinct(Event_ID, .keep_all = TRUE) %>%
  group_by(Year, YearDay) %>%
  summarize(total_surveys = n())

#collect total surveys in which Spp was sighted each date
occurrence_species_date <- target_data %>%
  group_by(Year, YearDay, Common_Name) %>%
  #eliminate duplicates
  distinct(GIS_Location_ID, .keep_all = TRUE) %>%
  summarize(species_surveys = n()) %>%
  ungroup() %>%
  #join by Date to compare with total
  left_join(all_surveys_date, by = c("Year" = "Year", "YearDay" = "YearDay")) %>%
  #calculate percent of daily surveys in which Spp sighted
  mutate(percent_surveys = species_surveys/total_surveys) %>%
  group_by(Common_Name, Year) %>%
  #calculate annual avg percentage of daily surveys in which Spp sighted
  summarize(avg_percent = mean(percent_surveys))

#plot of avg species occurrence by day and year?
plot_occurrenceDate <- ggplot(occurrence_species_date,
                              aes(Year, avg_percent)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(title = "Species Occurence Frequency by Date",
       y = "Average Annual Percent of Surveys Observed") +
  facet_wrap(~Common_Name, ncol = 4)

# TO DO: order facets by usefulness
