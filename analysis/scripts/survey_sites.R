############
#Visualize consistency of completion of planned surveys at each survey unit.
########
# Libraries used: dplyr, lubridate, ggplot2
########
# Madeleine Ward
# Last Edit: 2019 Mar 15
########

#create data frame with all survey dates at each unit, along with 
#number of observations and duration at each
unit_data_1 <-
  #combine field data (observation), location data, and events (key)
  left_join(tbl_Field_Data, tbl_Events,
            by = "Event_ID") %>%
  left_join(tbl_Locations,
            by = "Location_ID") %>%
  #find sum of all observations for all species, incl. non-targets, at each date
  group_by(GIS_Location_ID, Event_ID) %>%
  summarize(Total_Obs = sum(`Num_ Observed`)) %>%
  
  #re-join with events data to get date
  left_join(tbl_Events,
            by = "Event_ID") %>%
  #Julian dates (reused from data_wrangling.R)
  mutate(Date = floor_date(mdy_hm(Start_Date), unit = "day"),
         YearDay = yday(Date)) %>%
  filter(Year > 2002) %>%
  #select and order relevant variables
  select(GIS_Location_ID, Year, Date, YearDay, Day, Month, Year, Total_Obs, 
         Duration, Start_Time, End_Time, Event_Notes, 
         Location_ID, Event_ID) %>%
  #chose arbitrary value for considering a success based on observations above 0
  mutate(is_success = ifelse(Total_Obs == 0, "No", "Yes")) %>%
  filter(!is.na(GIS_Location_ID))

#same data frame but with only target species
#to-do: recreate without using species_data set;
#needs to include 0 values for observation number
unit_data_2 <-
  #combine field data (observation), location data, and events (key)
  left_join(target_data, tbl_Locations,
            by = "Location_ID") %>%
  #find sum of all observations for only target species at each date
  group_by(GIS_Location_ID, Event_ID) %>%
  summarize(Total_Obs = sum(Num_Obs)) %>%
  #re-join with events data to get date
  left_join(tbl_Events,
            by = "Event_ID") %>%
  #Julian dates (reused from data_wrangling.R)
  mutate(Date = floor_date(mdy_hm(Start_Date), unit = "day"),
         YearDay = yday(Date)) %>%
  #select and order relevant variables
  select(GIS_Location_ID, Date, YearDay, Total_Obs, 
         Duration, Start_Time, End_Time, Event_Notes, 
         Location_ID, Event_ID)

#based on non-target species; to-do: use target data
plot_units_1 <- unit_data_1 %>%
  ggplot(aes(YearDay,Year)) +
  #filled vs. unfilled shape shows viable survey
  geom_point(col="black", size=1.5, 
             aes(shape = as.factor(is_success))) +
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines 
       denote 1st of April, May, ... and Oct in non-leap years)") +
  #manually define shape values
  scale_shape_manual(values = c(21, 16), breaks = c("Yes", "No")) +
  #facet by unit location
  facet_wrap(~GIS_Location_ID)
