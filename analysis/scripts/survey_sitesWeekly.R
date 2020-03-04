############
#Visualize consistency of meeting intended frequency of surveys at each unit.
########
# Libraries used: dplyr, lubridate, ggplot2
########
# Joel Reynolds
# Last Edit: 2020 March 3
########

blah<- species_data %>%
  distinct(Date, .keep_all = TRUE) %>%
  select(Date, Year, YearDay) %>%
  mutate(Week=week(Date)) %>%
  group_by(Year) %>% count(Week)

plot_WeeklyFrequency <- ggplot() +
  # add layer with circles for all weeks & scale & transparency a function of
  # number of surveys w/in that week
  geom_point(data = blah,
             #plot with open circle shape & set size = freq of surveys per week
             aes(x = Week, y = Year, size=n, alpha=1/n), col="black", shape = 16)+
  # add vertical lines for April,May, June, July, Aug, Sept
  geom_vline(xintercept=c(14,18,22,27,31,36),colour="grey") +
  labs(x = "Julian Date",# \n(vertical lines: Monday April 2, April 30, May 28, July 2, July 30, and Sept 3, 2007)",
       title="") +
  #make background white
  theme_bw() +
  theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank()) +
  guides(alpha=FALSE)

# week 14 = April 2, 2007
# Week 18 April 30
# Week 22 May 28
# Week 27 July 2
# Week 31 July 30
# Week 36 Sept 3
