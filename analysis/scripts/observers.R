#Distribution of observers by survey date by year
#Distribution of observer experience(?) by survey date by year?
############
#
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

library(dplyr)
library(lubridate)
events_observers <- tbl_Events %>%
  group_by(Year, Month, Observer) %>%

  #count for each observer in each month
  summarize(count = n())

observers_events <- tbl_Events %>%
  group_by(Observer, Year, Month) %>%

  #count for each observer in each month
  summarize(count = n())
