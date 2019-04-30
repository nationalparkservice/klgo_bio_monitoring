############
# Graphs to see if the survey design's start and end dates each season 
# need to be modified to account for any observed changes in phenology
# of the target species.
########
# Libraries used: dplyr, ggplot2
########
# Madeleine Ward
# Last Edit: 2019 Mar 17
########

firstlast_surveys <- species_data %>%
  group_by(Year) %>%
  arrange(YearDay) 

first_surveys <- firstlast_surveys %>%
  slice(1) %>%
  select(Year, YearDay)
last_surveys <- firstlast_surveys %>%
  slice(n()) %>%
  select(Year, YearDay)


#dataset with both start and end dates for each target species
target_start_end <- target_data %>%
  mutate(is_first = ifelse(Date %in% first_surveys$Date, 1, 0)) %>%
  # now this will find first/last days
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

# this plot shows start dates of each survey, as well as
# first sighting of each target species

# used species HERG as placeholder until I can get facet to work
plot_timing_1 <- ggplot() +
  geom_point(data =target_start_end %>%
               filter(Start_End == "Start"
                      #, Species == "HERG"
               ), 
             aes(x=Year, y=YearDay), color="red") +
  geom_line(data =first_surveys
            #%>%
            #            filter(is_first == 1
            #                   )
            , 
            aes(x=Year, y=YearDay), color="black") +
  #geom_line(data =first_surveys 
            #%>%
  #            filter(is_first == 1
  #                   )
  #, 
   #         aes(x=Year, y=YearDay, color="blue")) +
labs(title = "Date of First Observation by Year", y = "Julian Date \n 
       (vertical lines denote 1st of April, May, ... 
     and Oct in non-leap years)")  +
#scale_color_discrete(values = c("First Day of Survey Season" = "black")) + 
  geom_hline(yintercept=c(yday(ymd(paste("2007-",c(4:6),"-1",sep="")))),
             linetype=2, colour="grey") + 
  theme(legend.position="bottom") +
  facet_wrap(~Common_Name)
             #, scales = "free_y"

plot_timing_2 <- ggplot() +
  geom_point(data =target_start_end %>%
               filter(Start_End == "End"
                      #, Species == "HERG"
               ), 
             aes(x=Year, y=YearDay), color="blue") +
  geom_line(data =last_surveys
            #%>%
            #            filter(is_first == 1
            #                   )
            , 
            aes(x=Year, y=YearDay), color="black") +
  labs(title = "Date of Last Observation by Year", y = "Julian Date \n 
       (vertical lines denote 1st of April, May, ... 
       and Oct in non-leap years)")  +
  #scale_color_discrete(values = c("First Day of Survey Season" = "black")) + 
  geom_hline(yintercept=c(yday(ymd(paste("2007-",c(4:6),"-1",sep="")))),
             linetype=2, colour="grey") + 
  theme(legend.position="bottom") +
  facet_wrap(~Common_Name, ncol = 3)

