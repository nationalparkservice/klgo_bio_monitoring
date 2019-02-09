############
# This script uses libraries "dplyr", "lubridate", and "tidyr" to wrangle species data
########
# Madeleine Ward, Joel Reynolds
# Last Edit: 2018 Oct 22; Updated: 2019 Feb 7
########


# re-build the necessary data frame from the various CSV files
# (basically reconstructing the query if the database was functioning).

# 1st left_join - attaches relevant Event data to each event in tbl_Field_Data (using Event_ID)
species_data <- left_join(tbl_Field_Data, tbl_Events,
                          by = "Event_ID") %>%
  # 2nd lef_join - attaches relevant Species names (Common, Latin, etc.) (using Species Code)
    left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  #subset out just nonzero observations after 2003
  filter(`Num_ Observed` > 0, Year >= 2003) %>%
  #create new Month_Day column & Julian Date column
  mutate(Date = floor_date(mdy_hm(Start_Date), unit = "day"),
         Month_Day = format(Date, "%m-%d"),
         JulDate = julian(Date)-julian(floor_date(Date, unit = "year"))+1) %>%
  #define grouping by Species
  group_by(Species, Year, Month_Day) %>%
  #add total observations column (by species by observation date)
  mutate(total_obs = sum(`Num_ Observed`)) %>%
  ungroup() %>%
  group_by(Species, Year) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  mutate(species_num = as.integer(as.factor(Species)))


# TO DO:
# filter to core field season (not all year)
# use species code, winnow to core spp
# use dotplot() directly

plot1<- ggplot(species_data, aes(Common_Name, JulDate)) + #store ggplot as plot object
  geom_point(col="tomato2", size=2) +   # Draw points
  geom_segment(aes(x=Common_Name, xend=Common_Name,  #2019 Feb 7 JR added xend
                   y=min(JulDate),
                   yend=max(JulDate)),
               linetype="dashed",
               size=0.1) +   # Draw dashed lines
  labs(title="Sightings by Species") +
  coord_flip()

print(plot1) # saves graphics file in analysis/figures/
library(lattice)
barchart(species_data$Month_Day)

######## 2019 Feb 7
# JR suggested tweaks to plot1: replace Month_Day w/ julian date
# use dotplot() command directly rather than make segments?


species_data_2007 <- left_join(tbl_Field_Data, tbl_Events,
                               by = "Event_ID") %>%
  left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  separate(Start_Date, c("Date", "Time_0"), sep = " ") %>%
  separate(Start_Time, c("Date_01", "Time_Start"), sep = " ") %>%
  #how to fit all these into one argument??
  separate(End_Time, c("Date_02", "Time_End"), sep = " ") %>%
  mutate(Date = mdy(Date),
         Day_Month = format(Date, "%m-%d")) %>%
  filter(`Num_ Observed` != 0, Year >= 2003) %>%
  group_by(Year) %>%
  arrange(Date) %>%
  mutate(Days_since_first = Date - Date[row_number()==1]) %>%
  ungroup() %>%

  group_by(Species) %>%
  arrange(Year) #%>%

  #take first observation from each year
  #filter(row_number()==1)

#species_data_2007$type <-
#ifelse(species_data_2007$`Num_ Observed` <
#mean(species_data_2007$`Num_ Observed`), "below", "above")
