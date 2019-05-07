############
# Create the survey & species data object "species_data".
########
# Libraries used: dplyr, lubridate, tidyr
########
# Joel Reynolds (repurposing code by Madeleine Ward)
# Last Edit: 2019 Feb 8
########


### TO DO: have copied all data frames created in their respective scripts.
# Want to re-frame species_data object as all-inclusive (join: tbl_Field_Data, tbl_Events, tlu_species_codes, tbl_Locations)
# and make all subsequent data frames created from the species_data object.
# Will eventually replace script data frames with modified versions.

# re-build the necessary data frame from the various CSV files
# (basically reconstructing the query as if the database was functioning).

# 1st join - attaches relevant Event data to each event in tbl_Field_Data (using Event_ID)
species_data <- full_join(tbl_Field_Data, tbl_Events,
                          by = "Event_ID") %>%
  # 2nd left_join - attaches relevant Species names (Common, Latin, etc.) (using Species Code)
  left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  # 3rd left join - attaches location & site information (using Location_ID)
  left_join(tbl_Locations,
            by = "Location_ID") %>%
  #strip HMS from Start_Date, create new Julian date column ('YearDay') & Fractional Month_Day
  mutate(Date = floor_date(mdy_hm(Start_Date), unit = "day"),
         YearDay = yday(Date)) %>%
  #         Month_DayFrac = format(Date, "%m-%d"),
  #subset out just columns we care about, re-order by interest, rename where necessary
  select(Date, Start_Date, Year, Month, Day, YearDay, Start_Time, End_Time, Duration,
         Species, ID, Category, Family, Common_Name, Latin_Name, Latin_Code,
         Num_Obs = 'Num_ Observed',
         GIS_Location_ID, X_Coord, Y_Coord, Coord_Units, Loc_Name, Loc_Notes,
         Temp, Cloud_Cover, Precip_Code,
         Wind_code, Wind_dir, Wave_ht, Tide, Tide_Level, Tide_State,
         Event_Group_ID, Protocol_Name, Observer, Event_Notes,
         Data_ID, Event_ID, Location_ID, Data_Location_ID) %>%
  #subset out just observations after 2003 (using renamed 'Num_Obs')
  filter(Year >= 2003) %>%
  #define grouping by Species
  group_by(Species, Year, YearDay) %>%
  #add total observations column (by species by observation date)
  mutate(obs_date = sum(Num_Obs)) %>%
  ungroup()
