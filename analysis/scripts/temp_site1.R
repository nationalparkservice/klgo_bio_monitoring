############
# Check Site 1's viability as survey site
########
# Libraries used:
########
# Madeleine Ward
# Last Edit: 2019 Apr 17
########

event_notes <- species_data %>%
  group_by(Year, YearDay, GIS_Location_ID) %>%
  mutate(all_observed = sum(total_obs_all)) %>%
  ungroup() %>%
  filter(GIS_Location_ID == "Site 1") %>%
  select(Event_Notes, all_observed, Year, YearDay, GIS_Location_ID) %>%
  group_by(Event_Notes)
