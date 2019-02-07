############
# This script uses libraries "dplyr", "lubridate", and "tidyr" to wrangle species data;
# and uses library "ggplot2" to visualize the data.
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

species_data <- left_join(tbl_Field_Data, tbl_Events,
                          by = "Event_ID") %>%
  left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  mutate(Date = substr(Start_Date, 1, 8),
         Date = mdy(Date),
         Month_Day = format(Date, "%m-%d")) %>%
  filter(`Num_ Observed` > 0, Year >= 2003) %>%
  group_by(Species, Year, Month_Day) %>%
  mutate(total_obs = sum(`Num_ Observed`)) #%>%
  #ungroup() %>%
  #group_by(Species, Year) %>%
  #filter(row_number()==1) %>%
  #ungroup() #%>%
  #arrange()

species_data$species_num= as.integer(as.factor(species_data$Species))
species_data <- left_join(tbl_Field_Data, tbl_Events,
                          by = "Event_ID") %>%
  left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  mutate(Date = substr(Start_Date, 1, 8),
         Date = mdy(Date),
         Month_Day = format(Date, "%m-%d")) %>%
  filter(`Num_ Observed` > 0, Year >= 2003) %>%
  group_by(Species, Year, Month_Day) %>%
  mutate(total_obs = sum(`Num_ Observed`)) %>%
  ungroup() %>%
  group_by(Species, Year) %>%
  filter(row_number()==1) %>%
  ungroup() #%>%
#arrange()

p1 <- ggplot(species_data, aes(Common_Name, Month_Day)) + #store ggplot as plot object
  geom_point(col="tomato2", size=3) +   # Draw points
  geom_segment(aes(x=Common_Name,
                   y=min(Month_Day),
                   yend=max(Month_Day)),
               linetype="dashed",
               size=0.1) +   # Draw dashed lines
  labs(title="Dot Plot",
       subtitle="Common Name vs. Sighting") +
  coord_flip()



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
