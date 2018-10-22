# title
############
# This script examines the interaction between tidal state and sequencing of observation sites
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

library(dplyr)
tide_states <- tbl_Events %>%
  full_join(tlu_tide_state, by = c("Tide_State" = "code")) %>%
  full_join(tlu_locations, by = "Location_ID")
