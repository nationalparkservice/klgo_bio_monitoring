############
#Visualize consistency of completion of planned surveys at each survey unit.
########
# Libraries used: dplyr, lubridate, ggplot2
########
# Madeleine Ward, Joel Reynolds
# Last Edit: 2019 Mar 24
########

#create data frame with all survey dates at each unit, along with
#number of observations and duration at each
# NOTE: based on all species;
#TO DO: filter to just target species data
survey_units <- survey_duration %>%
  #chose arbitrary value for considering a success based on seeing any birds (observations above 0)
  mutate(is_success = ifelse(total_obs_site == 0, "No", "Yes")) %>%
  filter(!is.na(GIS_Location_ID)) # ignore observations not associated with a survey site

# based on all species;
#TO DO: filter to just target species data
plot_unitSuccess <- survey_units %>%
  ggplot(aes(YearDay,Year)) +
  #filled vs. unfilled shape shows viable survey
  geom_point(col="black", size=1,
             aes(shape = as.factor(is_success))) +
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)") +
  #manually define shape values
  scale_shape_manual(values = c(21, 16), breaks = c("Yes", "No"), name="Completed Survey?") +
  #facet by unit location
  facet_wrap(~GIS_Location_ID)
