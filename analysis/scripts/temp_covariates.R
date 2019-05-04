############
# Examine various covariates and distributions.
########
# Libraries used: ggplot2, stringr
########
# Madeleine Ward
# Last Edit: 2019 Apr 27
########
library(stringr)
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
print(plot_wind)
## Wind speed by year & site
plot_windsite <- plot_wind +
  facet_wrap(~GIS_Location_ID)
print(plot_windsite)

### Distribution of wave conditions

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
print(plot_waves)
## Wave height by year & site
plot_wavesite <- plot_waves +
  facet_wrap(~GIS_Location_ID, ncol =2)
print(plot_wavesite)

## Distribution of tide states by year
#many problems with this graph...
plot_tides <- ggplot(test <- tbl_Events %>%
                       left_join(tbl_Locations, by = "Location_ID") %>%
                                   mutate(All_tides = substr(Tide_Level, start = 1, stop = 1), locale = "en") %>%
                       filter(Year >= 2003
                              #,
                              #!is.na(All_tides)
                              , 
                              !is.na(GIS_Location_ID)
                              ),
                     aes(as.factor(Year))) +
  geom_bar(aes(fill = as.factor(Tide_Level))) +
  scale_fill_discrete(labels = tlu_tide_level$tide_level,
                      name = "Tide Level") +
  labs(title = "Distribution of Tide Levels Across Years",
       x = "Year", y = "Count") +
  coord_flip() + 
  theme(legend.position="bottom")
print(plot_tides)

plot_tidesite <- plot_tides +
  facet_wrap(~GIS_Location_ID, ncol =2)
print(plot_tidesite)

### Covariates

## Distribution of survey time by weather conditions
plot_timeweather <- species_data %>%
  filter(Year >= 2003) %>%
  #distinct(Date, .keep_all = TRUE) %>%
  #filter(!is.na(Wind_code)) %>%
  ggplot(aes(YearDay,Year)) +   
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May,
       ... and Oct in non-leap years)") +
  facet_wrap(~GIS_Location_ID)

# To do: change color scheme so no one goes blind looking at this

# By wind code
plot_timewind <- plot_timeweather +
  geom_point(aes(color = as.factor(Wind_code)),size = 2) +
  scale_color_discrete(labels = tlu_wind_codes$Wind_Speed,
                       name = "Wind Speed") +
  labs(title = "Survey Timing and Wind Conditions")
print(plot_timewind)

# By wave height
plot_timewave <- plot_timeweather +
  geom_point(aes(color = as.factor(Wave_ht)),size = 2) +
  scale_color_discrete(labels = tlu_wave_codes$Description,
                       name = "Waves") +
  theme(legend.position = "bottom") +
  labs(title = "Survey Timing and Wave Height")
print(plot_timewave)

## Total number species by weather conditions
# By wind code
plot_targetsweather <- target_data %>%
  group_by(Date) %>%
  mutate(total_obs = sum(obs_date)) 

plot_targetswind <- plot_targetsweather %>%
  ggplot(aes(as.factor(Wind_code), total_obs)) +
  geom_boxplot() +
  coord_flip() +
  coord_cartesian(ylim = c(0, 10000)) 
#+ facet_wrap(~Common_Name)
print(plot_targetswind)

plot_targetswave <- plot_targetsweather %>%
  ggplot(aes(as.factor(Wave_ht), obs_date)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 1000))
print(plot_targetswave)

### Temperature by 