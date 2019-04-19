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

first_surveys <- species_data %>%
  group_by(Year) %>%
  arrange(YearDay) %>%
  slice(1) 

#dataset with both start and end dates for each target species
target_start_end <- target_data %>%
  mutate(is_first = ifelse(Event_ID %in% first_surveys$Event_ID, 1, 0)) %>%
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
  geom_line(data =target_start_end %>%
              filter(is_first == 1
                     ), 
            aes(x=Year, y=YearDay, color="blue")) +
  geom_line(data =target_start_end %>%
              filter(Start_End == "Start"
                     , Species == "HERG"
                     ), 
            aes(x=Year, y=YearDay, color="red")) +
labs(title = "Date of First Observation by Year", y = "Julian Date \n 
       (vertical lines denote 1st of April, May, ... 
     and Oct in non-leap years)")  +
scale_color_discrete(name = "", labels = c("First Day of Survey Season",
                                           "First Day of Species Sighting")) + 
  geom_hline(yintercept=c(yday(ymd(paste("2007-",c(4:6),"-1",sep="")))),
             linetype=2, colour="grey") + 
  theme(legend.position="bottom") 
#+
#  facet_wrap(~target_start_end$Common_Name
             #, scales = "free_y"
#  )


#explore more succinct way with dplyr
#df1 <- data.frame(dates = x,Variable = rnorm(mean = 0.75,nmonths))
#df2 <- data.frame(dates = x,Variable = rnorm(mean = -0.75,nmonths))

#df3 <- df1 %>%  mutate(Type = 'Amocycillin') %>%
#  bind_rows(df2 %>%
#              mutate(Type = 'Penicillin'))


#ggplot(df3,aes(y = Variable,x = dates,color = Type)) + 
#  geom_line() +
#  ggtitle("Merged datasets")

