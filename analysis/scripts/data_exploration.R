# check dates and unit of first non-zero counts each yea for each spp (relative to first survey date)
############
# This script uses library("dplyr") to wrangle species data.
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

library(dplyr)
library(tidyr)
library(lubridate)
species_data_names <- left_join(species_datafrom_Excel, tlu_species_codes, by = c("Species" = "Code")) %>%
  separate(Date, c("Date1", "Time"), sep = " ") %>%
  mutate(Date = mdy(Date1))
  #group_by()
