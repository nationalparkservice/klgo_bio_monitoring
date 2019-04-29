############
# Examine various covariates and distributions.
########
# Libraries used: ggplot2
########
# Madeleine Ward
# Last Edit: 2019 Apr 27
########

### Distribution of weather conditions

# Distribution of wind speed by year
plot_wind <- ggplot(tbl_Events %>%
                      left_join(tbl_Locations, by = "Location_ID") %>%
                      filter(Year > 2003, !is.na(Wind_code), !is.na(GIS_Location_ID)),
                    aes(as.factor(Year))) +
  geom_bar(aes(fill = as.factor(Wind_code))) +
  scale_fill_discrete(labels = tlu_wind_codes$Wind_Speed,
                      name = "Wind Speed") +
  labs(title = "Distribution of Wind Conditions Across Years",
       x = "Year", y = "Count") +
  theme(axis.text.x = element_text(angle=65, vjust = .6))
plot_wind
# Wind speed by year & site
plot_windsite <- plot_wind +
  facet_wrap(~GIS_Location_ID)
plot_windsite


