############
# Looks at variation in survey duration at each site across days of season, year, and survey site.
########
# Libraries used: ggplot2, dplyr
########
# Madeleine Ward
# Last Edit: 2019 Mar 17
########

#will delete this when all datasets are put into wrangling
unit_data_2 <-
  #combine field data (observation), location data, and events (key)
  left_join(target_data, tbl_Locations,
            by = "Location_ID") %>%
  #find sum of all observations for only target species at each date
  group_by(GIS_Location_ID, Event_ID) %>%
  summarize(Total_Obs = sum(Num_Obs)) %>%
  #re-join with events data to get date
  left_join(tbl_Events,
            by = "Event_ID") %>%
  #Julian dates (reused from data_wrangling.R)
  mutate(Date = floor_date(mdy_hm(Start_Date), unit = "day"),
         YearDay = yday(Date)) %>%
  #select and order relevant variables
  select(GIS_Location_ID, Year, Date, YearDay, Total_Obs, 
         Duration, Start_Time, End_Time, Event_Notes, 
         Location_ID, Event_ID)

# Use unit_data_2 from survey_sites.R
duration_data <- unit_data_2 %>%
  # filter for negative (error) durations, NA Site IDs
  filter(Duration >= 0, !is.na(GIS_Location_ID))

# group by year to get separate boxplot for each year
plot_duration <- ggplot(duration_data, aes(Year, Duration, group = Year
)) +
  geom_boxplot() +
  # will result in vertical plots; flip
  coord_flip() +
  # facet by site and free the x scale to accommodate site-specific outliers
  facet_wrap(~GIS_Location_ID, scales = "free_x") +
  labs(title = "Survey Duration by Site", y = "Duration (min)")

# TO DO: add descriptions of the sites as subtitles