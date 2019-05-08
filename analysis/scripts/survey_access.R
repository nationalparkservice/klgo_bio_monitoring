############
# Measure site accessibility
########
# Libraries used: dplyr, ggplot2
########
# Madeleine Ward
# Last Edit: 2019 May 7
########

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

temp_access3 <- target_data %>%
  mutate(time_block = as.numeric(substr(Start_Time,
                                        nchar(Start_Time)-4, 
                                        nchar(Start_Time)-3))) 
plot1 <- ggplot(temp_access3, aes(time_block)) +
  geom_histogram()

temp_access2 <- target_data %>%
  mutate(time_block = substr(Start_Time, 
                             nchar(Start_Time)-4, nchar(Start_Time)-3)) %>%
  #mutate(block = as.numeric(substr(Start_Time, 
  #                                 nchar(Start_Time)-4, 
  #                                 nchar(Start_Time)-3)),
  #       time_block = ifelse())
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


plot_access2 <- ggplot(temp_access2, aes(time_block, daily_obs)) +
  geom_point() +
  geom_line(aes(color = as.factor(Year))) +
  facet_wrap(~GIS_Location_ID)

survey_success <- target_data %>%
  mutate(time_block = substr(Start_Time, 
                             nchar(Start_Time)-4, nchar(Start_Time)-3)) %>%
  select(GIS_Location_ID, Year, YearDay, time_block, Common_Name, Num_Obs) %>%
  na.omit() %>%
  group_by(GIS_Location_ID, Year) %>%
  mutate(obs_year = sum(Num_Obs)) %>%
  ungroup() %>%
  group_by(GIS_Location_ID, Year, time_block) %>%
  mutate(obs_time = sum(Num_Obs),
         percent_obs = obs_time/ obs_year) %>%
  arrange(GIS_Location_ID, Year, time_block) %>%
  slice(1) %>%
  select(-Common_Name, -Num_Obs, -YearDay) 

plot_success <- ggplot(survey_success, aes(time_block, percent_obs)) +
  geom_bar(aes(fill = Year), stat = "identity") +
  #coord_flip() +
  facet_wrap(~GIS_Location_ID, ncol = 3)
plot_success

plot_success2 <- ggplot(survey_success, aes(Year, percent_obs)) +
  geom_bar(aes(fill = time_block), stat = "identity") +
  coord_flip() +
  facet_wrap(~GIS_Location_ID, ncol = 3)
plot_success2

plot_success3 <- ggplot() +
  geom_point(data = survey_success,
            aes(x= as.numeric(time_block), y = percent_obs, 
                color = Year),
            alpha = .8, size = 2) +
  facet_wrap(~GIS_Location_ID)
plot_success3
