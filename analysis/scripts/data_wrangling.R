############
# Create the survey & species data object "species_data".
########
# Libraries used: dplyr, lubridate, tidyr
########
# Joel Reynolds (repurposing code by Madeleine Ward)
# Last Edit: 2019 Feb 8
########


### TO DO: have copied all data frames created in their respective scripts.
# Want to re-frame species_data objetc as all-inclusive (join: tbl_Field_Data, tbl_Events, tlu_species_codes, tbl_Locations)
# and make all subsequent data frames created from the species_data object.
# Will eventually replace script data frames with modified versions.

# re-build the necessary data frame from the various CSV files
# (basically reconstructing the query as if the database was functioning).

# 1st left_join - attaches relevant Event data to each event in tbl_Field_Data (using Event_ID)
species_data <- left_join(tbl_Field_Data, tbl_Events,
                          by = "Event_ID") %>%
  # 2nd left_join - attaches relevant Species names (Common, Latin, etc.) (using Species Code)
  left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  #subset out just columns we care about, re-order by interest, rename where necessary
  select(Start_Date, Year, Month, Day, Start_Time, End_Time, Duration,
         Location_ID,
         Species, ID, Category, Family, Common_Name, Latin_Name, Latin_Code,
         Num_Obs = 'Num_ Observed',
         Temp, Cloud_Cover, Precip_Code,
         Wind_code, Wind_dir, Wave_ht, Tide, Tide_Level, Tide_State,
         Event_Group_ID, Protocol_Name, Observer, Event_Notes,
         Data_ID, Event_ID, Data_Location_ID) %>%
  #subset out just nonzero observations after 2003 (using renamed 'Num_Obs')
  filter(Num_Obs > 0, Year >= 2003) %>%
  #strip HMS from Start_Date, create new Julian date column ('YearDay') & Fractional Month_Day
  mutate(Date = floor_date(mdy_hm(Start_Date), unit = "day"),
         YearDay = yday(Date)) %>%
  #         Month_DayFrac = format(Date, "%m-%d"),
  #define grouping by Species
  group_by(Species, Year, YearDay) %>%
  #add total observations column (by species by observation date)
  mutate(total_obs = sum(Num_Obs)) %>%
  ungroup()

###temp data sets
###
###target_species.R
#create vector of target species types
targetList <- c("loon", "grebe", "cormorant", "heron", "duck", "goose", "plover", "sandpiper", "gull", "alcid", "kingfisher")

#use data frame species_data from data_wrangling.R
target_data <- species_data %>%
  #filter for species in targetList
  filter(str_detect(str_to_lower(Common_Name, locale = "en"), paste(targetList, collapse="|")))

###temp
###survey_dates.R
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

### temp
###survey_sites.R

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
  select(GIS_Location_ID, Year, Date, YearDay, Total_Obs, 
         Duration, Start_Time, End_Time, Event_Notes, 
         Location_ID, Event_ID)

###temp
###survey_duration.R
# Use unit_data_2 from survey_sites.R
duration_data <- unit_data_2 %>%
  # filter for negative (error) durations, NA Site IDs
  filter(Duration >= 0, !is.na(GIS_Location_ID))


###
###survey_timing_EDA.R
#unfinished

###
###UNUSED
##time_duration.R
##units_species.R
