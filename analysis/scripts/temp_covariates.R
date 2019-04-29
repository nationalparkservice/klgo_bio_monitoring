############
# Examine various covariates and distributions.
########
# Libraries used: ggplot2
########
# Madeleine Ward
# Last Edit: 2019 Apr 27
########

### Distribution of weather conditions

## Distribution of wind speed by year
plot_wind <- ggplot(tbl_Events %>%
                      left_join(tbl_Locations, by = "Location_ID") %>%
                      filter(Year > 2003, !is.na(Wind_code), !is.na(GIS_Location_ID)),
                    aes(as.factor(Year))) +
  geom_bar(aes(fill = as.factor(Wind_code))) +
  scale_fill_discrete(labels = tlu_wind_codes$Wind_Speed,
                      name = "Wind Speed") +
  labs(title = "Distribution of Wind Conditions Across Years",
       x = "Year", y = "Count")
plot_wind
## Wind speed by year & site
plot_windsite <- plot_wind +
  facet_wrap(~GIS_Location_ID)
plot_windsite

## Distribution of wave height by year
plot_waves <- ggplot(tbl_Events %>%
                      left_join(tbl_Locations, by = "Location_ID") %>%
                      filter(Year > 2003, !is.na(Wave_ht), !is.na(GIS_Location_ID)),
                    aes(as.factor(Year))) +
  # still need to change order of fill var
  geom_bar(aes(fill = as.factor(Wave_ht))) +
  scale_fill_discrete(labels = tlu_wave_codes$Description,
                      name = "Waves") +
  labs(title = "Distribution of Wave Conditions Across Years",
       x = "Year", y = "Count") +
  coord_flip() + 
  theme(legend.position="bottom")
plot_waves
## Wind speed by year & site
plot_windsite <- plot_wind +
  facet_wrap(~GIS_Location_ID, ncol =2)
plot_windsite

### Covariates

## Distribution of survey time by weather conditions
# Needs survey_timing_EDA.R plots created first
plot_timewind <- species_data %>%
  distinct(Date, .keep_all = TRUE) %>%
  filter(!is.na(Wind_code)) %>%
  ggplot(aes(YearDay,Year)) +
  geom_point(aes(fill = as.factor(Wind_code))) +   # Draw points
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May,
       ... and Oct in non-leap years)")
plot_timewind
