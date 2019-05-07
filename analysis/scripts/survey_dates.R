############
# Graphs to see if the survey design's start and end dates each season 
# need to be modified to account for any observed changes in phenology
# of the target species.
########
# Libraries used: dplyr, ggplot2, ggforce
########
# Madeleine Ward
# Last Edit: 2019 Mar 17
########

# collect all survey dates and arrange by timing
firstlast_surveys <- species_data %>%
  select(Year, YearDay) %>%
  group_by(Year) %>%
  arrange(YearDay) 

#dataset with both start and end dates for each target species
target_start_end <- target_data %>%
  # find first/last days, by year
  group_by(Common_Name, Year) %>%
  arrange(YearDay) %>%
  # take first and last day for each group
  slice(c(1, n())) %>%
  # mark whether it is the first or last day each year
  mutate(Start_End = ifelse(row_number()==1, "Start", "End")) %>%
  ungroup() 

## this plot shows start dates of each survey, as well as
# first sighting of each target species
plot_timing_1 <- ggplot() +
  # select all species-specific start dates
  geom_point(data =target_start_end %>%
               filter(Start_End == "Start"
                      #, Species == "HERG"
               ), 
             aes(x=Year, y=YearDay), color="red") +
  # select all survey start dates
  geom_line(data =firstlast_surveys %>%
              slice(1), 
            aes(x=Year, y=YearDay), color="black") +
  # titles and Julian date labels
labs(title = "Date of First Observation by Year", y = "Julian Date \n 
       (vertical lines denote 1st of April, May, ... 
     and Oct in non-leap years)")  +
  geom_hline(yintercept=c(yday(ymd(paste("2007-",c(4:6),"-1",sep="")))),
             linetype=2, colour="grey") + 
  # facet by species; try to separate into visible columns
  facet_wrap_paginate(~Common_Name, ncol = 3
             #, scales = "free_y")
  )

## last sighting of each species
plot_timing_2 <- ggplot() +
  # select all species-specific end dates
  geom_point(data =target_start_end %>%
               filter(Start_End == "End"), 
             aes(x=Year, y=YearDay), color="blue") +
  # select all survey end dates
  geom_line(data =firstlast_surveys %>%
              slice(n()), 
            aes(x=Year, y=YearDay), color="black") +
  # titles and Julian date labels
  labs(title = "Date of Last Observation by Year", y = "Julian Date \n 
       (vertical lines denote 1st of April, May, ... 
       and Oct in non-leap years)")  +
  #scale_color_discrete(values = c("First Day of Survey Season" = "black")) + 
  geom_hline(yintercept=c(yday(ymd(paste("2007-",c(4:6),"-1",sep="")))),
             linetype=2, colour="grey") + 
  facet_wrap_paginate(~Common_Name, ncol = 3)

## layering both first/last sightings
#plot_timing_3 <- ggplot() +
 # geom_point(data =target_start_end, 
#             aes(x=Year, y=YearDay, color = Start_End)) +
#  geom_line(data =firstlast_surveys %>%
#              slice(1), 
#            aes(x=Year, y=YearDay), color="black") +
#  geom_line(data =firstlast_surveys %>%
#              slice(n()), 
#            aes(x=Year, y=YearDay), color="black") +
  # titles and Julian date labels
#  labs(title = "Date of First & Last Observations by Year", y = "Julian Date \n 
#       (vertical lines denote 1st of April, May, ... 
#       and Oct in non-leap years)")  +
  #scale_color_discrete(values = c("First Day of Survey Season" = "black")) + 
#  geom_hline(yintercept=c(yday(ymd(paste("2007-",c(4:6),"-1",sep="")))),
#             linetype=2, colour="grey") + 
#  facet_wrap_paginate(~Common_Name, ncol = 3)
