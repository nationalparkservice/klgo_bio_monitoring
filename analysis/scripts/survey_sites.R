############
#Visualize consistency of completion of planned surveys at each survey unit.
########
# Libraries used: 
########
# Madeleine Ward
# Last Edit: 2019 Mar 15
########

unit_data <-
  left_join(species_data <- left_join(tbl_Field_Data, tbl_Events,
                                      by = "Event_ID") %>%
              left_join(tlu_species_codes,
                        by = c("Species" = "Code")) %>%
              separate(Start_Date, c("Date", "Time_0"), sep = " ") %>%
              separate(Start_Time, c("Date_01", "Time_Start"), sep = " ") %>%
              #how to fit all these into one argument??
              separate(End_Time, c("Date_02", "Time_End"), sep = " ") %>%
              mutate(Date = mdy(Date)) %>%
              filter(Year >= 2003) %>%
              group_by(Year) %>%
              arrange(Date) %>%
              mutate(Days_since_first = Date - Date[row_number()==1]),
            tbl_Locations,
            by = "Location_ID") %>%
  group_by(GIS_Location_ID, Year, Days_since_first, Species) %>%
  summarize(total_Observed = sum(`Num_ Observed`)) %>%
  left_join(tlu_species_codes, by = c("Species" = "Code"))

plot_units_1 <- species_target_data %>%
  ggplot(aes(YearDay,Year)) +
  geom_point(col="black", size=1.5, aes(shape = as.factor(is_target))) +   # Draw points
  geom_vline(xintercept=c(yday(ymd(paste("2007-",c(4:10),"-1",sep="")))),
             linetype=2, colour="grey") +
  labs(x="Julian Date \n (vertical lines denote 1st of April, May, ... and Oct in non-leap years)")+
  scale_shape_manual(values = c(16, 21)) +
  theme_bw() +
  facet_wrap(~Common_Name)