############
# Measure site accessibility
########
# Libraries used: 
########
# Madeleine Ward
# Last Edit: 2019 May 7
########

#SECOND graph: [THIS IS SECONDARY PRIORITY] x axis is Time of Day, 
#perhaps broken in to 1 or 2 hour blocks , y axis is ....
#this is a tough one so totally open to your ideas. How about y axis is 
#% [0, 1.0] and for each year there is a different curve showing the % of
#planned surveys (as defined above) that were successfully completed that 
#season within that time block; facet by site. So we are seeing whether there 
#are consistently problematic times of day at each site. 

temp_access <- target_data %>%
  mutate(time_block = substr(Start_Time, 
                             nchar(Start_Time)-4, nchar(Start_Time)-3)) %>%
  group_by(GIS_Location_ID, Year, time_block) %>%
  mutate(site_time_obs = sum(Num_Obs)) %>%
  ungroup()

# 
plot_access <- ggplot(temp_access %>%
                        filter(!is.na(GIS_Location_ID), !is.na(time_block))) +
  geom_boxplot(aes(time_block, site_time_obs)) +
  coord_flip(ylim = c(0, 1200)) +
  labs() +
  facet_wrap(~GIS_Location_ID, ncol = 3 
             #, scales = "free_x"
             )
plot_access

#plot_yearaccess <- ggplot(temp_access %>%
#                            filter(!is.na(GIS_Location_ID)) %>%
#                            group_by(Year, GIS_Location_ID) %>%
#                            mutate(site_year_obs = sum(Num_Obs))) +
#  geom_boxplot(aes(Year, site_year_obs)) +
  #coord_flip(ylim = c(0, 1200)) +
  # coord_cartesian(ylim = c(0, 1000)) +
#  facet_wrap(~GIS_Location_ID, ncol = 3 
             #, scales = "free_x"
#  )
#plot_yearaccess

temp_access2 <- target_data %>%
  mutate(time_block = substr(Start_Time, 
                             nchar(Start_Time)-4, nchar(Start_Time)-3)) %>%
  group_by(GIS_Location_ID, Year, time_block) %>%
  arrange(GIS_Location_ID, Year, time_block) %>%
  select(GIS_Location_ID, Year, YearDay, time_block, Species, Num_Obs) %>%
  filter(!is.na(Num_Obs)) %>%
  #mutate(mean_obs = sum(Num_Obs)/n()) %>%
  ungroup() %>%
  group_by(GIS_Location_ID, Year, time_block, YearDay) %>%
  mutate(daily_obs = sum(Num_Obs)) %>%
  ungroup() %>%
  group_by(GIS_Location_ID, Year, time_block) %>%
  mutate(mean_obs = sum(daily_obs)/n())
  
  mutate(all_obs = sum(Num_Obs),
         success = ifelse(n() > 3, 1, 0)) %>%
  summarize(all_dates = n(),
            percent_success = sum(success)/all_dates) %>%
  arrange(GIS_Location_ID, Year, time_block)

plot_access2 <- ggplot(temp_access2, aes(time_block, daily_obs)) +
  geom_point() +
  geom_line(aes(color = as.factor(Year))) +
  facet_wrap(~GIS_Location_ID)
plot_access2

ggplot(mpg, aes(class, cty))
g + geom_boxplot(varwidth=T, fill="plum") + 
  labs(title="Box plot", 
       subtitle="City Mileage grouped by Class of vehicle",
       caption="Source: mpg",
       x="Class of Vehicle",
       y="City Mileage")
