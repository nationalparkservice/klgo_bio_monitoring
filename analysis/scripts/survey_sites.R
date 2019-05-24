############
#Visualize consistency of completion of planned surveys at each survey unit.
########
# Libraries used: dplyr, lubridate, ggplot2
########
# Madeleine Ward, Joel Reynolds
# Last Edit: 2019 May 23
########

plot_unitSuccess <- ggplot() +
  
  # add layer with open circles for all dates
  geom_point(data = species_data %>%
               distinct(Date, .keep_all = TRUE) %>%
               select(Date, Year, YearDay),
             #plot with open circle shape & greater transparency
             aes(x = YearDay, y = Year), shape = 1, size = 3, alpha = .8) + 
  
  # add layer with successful surveys in each site
  geom_point(data = survey_duration %>%
               filter(total_obs_site > 0, !is.na(GIS_Location_ID)),
             aes(YearDay, Year),
             col="black", size=3) +
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x = "Julian Date \n (vertical lines denote 1st of 
       #April, May, ... and Oct in non-leap years)",
       title = "Survey Success Across Sites (Measured by Non-Zero Obs)") +
  #make background white
  theme_bw() +
  
  # facet by unit
  facet_wrap(~GIS_Location_ID)

