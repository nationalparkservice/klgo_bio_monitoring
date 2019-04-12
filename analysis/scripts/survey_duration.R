############
# Looks at variation in survey duration at each site across days of season, year, and survey site.
########
# Libraries used: ggplot2, dplyr
########
# Madeleine Ward (2019 Mar 17); Joel Reynolds (2019 Apr 11)
# Last Edit: 2019 Mar 17
########


# Use unit_data_2 from survey_sites.R
#duration_data <- unit_data_2 %>%
  # filter for negative (error) durations, NA Site IDs
 # filter(Duration >= 0, !is.na(GIS_Location_ID))

survey_duration <- target_data %>%
  #find sum of all observations for all target species, at each date
  group_by(GIS_Location_ID, Event_ID) %>%
  mutate (total_obs_site = sum(Num_Obs)) %>%
  ungroup()

# group by year to get separate boxplot for each year
plot_duration <-
  ggplot(survey_duration %>%
           # filter for negative (error) durations, NA Site IDs
           filter(Duration >= 0, !is.na(GIS_Location_ID)),
         aes(Year, Duration, group = Year)) +
  geom_boxplot() +
  # will result in vertical plots; flip
  coord_flip() +
  # facet by site and free the x scale to accommodate site-specific outliers
  #facet_wrap(~GIS_Location_ID, scales = "free_x") +

  # JR: actually, prefer keeping x scale fixed to support easier comparison
  # across panels (sites).
  facet_wrap(~GIS_Location_ID, scales = "fixed") +
  # Resolve extreme observations by fixing scale limits at 180 min (3 hrs)
  # with vertical reference grid at 30 min intervals (rather than default 50)
  scale_y_continuous(limits=c(0,185),breaks = seq(0,180,30),labels = c("0","","60","","120","","180"))+
  theme(panel.grid.minor = element_blank()) + #, panel.grid.major.y=element_blank()) +
  labs(title = "Survey Duration by Site", y = "Duration (min)",
       caption="(1 survey > 180 minutes at Site 6 not shown)")


# TO DO: add descriptions of the sites as subtitles
