############
# Measure site accessibility
########
# Libraries used: dplyr, ggplot2
########
# Madeleine Ward
# Last Edit: 2019 May 24
########

# create frame of all time blocks
all_dates <- target_data %>%
  #each hour is a block, from 0-24
  mutate(time_block = substr(Start_Time, 
                             nchar(Start_Time)-4, nchar(Start_Time)-3)) %>%
  
  #keep only one copy of date and select year, date, and block
  distinct(Date, .keep_all = TRUE) %>%
  select(Date, Year, YearDay, time_block) %>%
  group_by(Year, time_block) %>%
  #count all surveys performed in the time block
  summarize(block_instance = n())

# UNFINISHED: MESSY AND ERRORED
# this frame is meant to collect surveys in time block per year for each site;
# but some are greater than reported yearly surveys within block so 
# something went wrong
access_data <- target_data %>%
  mutate(time_block = substr(Start_Time, 
                             nchar(Start_Time)-4, nchar(Start_Time)-3)) %>%
  #select only one date (event) in each site
  distinct(Date, GIS_Location_ID, .keep_all = TRUE) %>%
  group_by(GIS_Location_ID, Year, time_block) %>%
  #number of surveys within time block in each site per year
  summarize(site_block_instance = n()) %>%
  ungroup() %>%
  full_join(all_dates, by = c("Year" = "Year", "time_block" = "time_block")) %>%
  
  #calculate the percent of planned (all) surveys completed in each site during each time
  group_by(GIS_Location_ID, Year, time_block) %>%
  mutate(percent_block = site_block_instance/block_instance)

#this is unfinished; some percents above 1 (see above)
plot_access <- ggplot(access_data,
                      aes(time_block, percent_block)) +
  geom_point() +
  facet_wrap(~GIS_Location_ID)

