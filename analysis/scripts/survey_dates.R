############
# Graphs to see if the survey design's start and end dates each season 
# need to be modified to account for any observed changes in phenology
# of the target species.
########
# Libraries used: dplyr, lubridate, tidyr
########
# Madeleine Ward
# Last Edit: 2019 Mar 17
########

#dataset with both start and end dates for each target species
target_start_end <- target_data %>%
  left_join(tbl_Locations, by = "Location_ID") %>%
  # group by year
  group_by(Common_Name, Year
           #         , Location_ID
  ) %>%
  arrange(YearDay) %>%
  # take first and last day for each group
  slice(c(1, n())) %>%
  # mark whether it is the first or last day each year
  mutate(Start_End = ifelse(row_number()==1, "Start", "End")) %>%
  ungroup() 

# separate sets for both start and end dates
target_start <- target_start_end %>%
  filter(Start_End == "Start")

target_end <- target_start_end %>%
  filter(Start_End == "End")

# this plot shows start dates connected with piecewise lines
# MADELEINE: let's discuss how this could be modified to include a sense
# of WHEN, each year, the surveys actually started. E.g., so the viewer can
# separate out any changes in species phenology from changes in survey timing and effort levels.
# ALSO may need to think about either dropping some spp (e.g., Am Black Duck) or otherwise
# constraining the range of the y axis so really focus on early (or late) period.
plot_timing_1 <- 
  ggplot(target_start, aes(x= Year, y= YearDay)) +
  #ggplot(target_start_end, aes(x= Year, y= YearDay)) +
  geom_point(
    # to put both start/end on the same plot:
    #aes(color = as.factor(Start_End))
  ) +
  geom_line()  +
  #geom_smooth() +
  facet_wrap(~Common_Name
             #, scales = "free_y"
  ) +
  # add horizontal reference lines to denote start of months...
  labs(title = "Date of First Observation by Year", y = "Julian Date \n 
       (horizontal lines denote 1st of April, May, ... and Oct in non-leap years)") +
  geom_hline(yintercept=c(yday(ymd(paste("2007-",c(4:6),"-1",sep="")))),
             linetype=2, colour="grey")

# same graph but for end dates
plot_timing_2 <- 
  ggplot(target_end, aes(x= Year, y= YearDay)) +
  geom_point() +
  geom_line()  +
  #geom_smooth() +
  facet_wrap(~Common_Name
             #, scales = "free_y"
  ) +
  labs(title = "Date of First Observation by Year", y = "Julian Date \n 
       (vertical lines denote 1st of April, May, ... and Oct in non-leap years)") 
