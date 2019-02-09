############
# Create the survey & species data object "species_data".
########
# Libraries used: dplyr, lubridate, tidyr
########
# Joel Reynolds (repurposing code by Madeleine Ward)
# Last Edit: 2019 Feb 8
########


# re-build the necessary data frame from the various CSV files
# (basically reconstructing the query as if the database was functioning).

# 1st left_join - attaches relevant Event data to each event in tbl_Field_Data (using Event_ID)
species_data <- left_join(tbl_Field_Data, tbl_Events,
                          by = "Event_ID") %>%
  # 2nd lef_join - attaches relevant Species names (Common, Latin, etc.) (using Species Code)
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

