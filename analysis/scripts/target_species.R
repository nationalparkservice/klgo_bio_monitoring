# Subset out data on target species from field dataset
########
# Libraries used: dplyr
########
# Madeleine Ward
# Last Edit: 2019 Feb 23, 2019 Aug 12 added survey_duration creation
########

#create vector of target species types
targetList <- c("loon", "grebe", "cormorant", "heron", "duck", "goose", "plover", "sandpiper", "gull", "alcid", "kingfisher")

#use data frame species_data from data_wrangling.R
target_data <- species_data %>%
  #filter for species in targetList
  filter(str_detect(str_to_lower(Common_Name, locale = "en"), paste(targetList, collapse="|")))

survey_duration <- target_data %>%
  #find sum of all observations for all target species, on each date
  group_by(GIS_Location_ID, Date) %>%
  mutate (total_obs_site = sum(Num_Obs)) %>%
  ungroup()


# Need to define the species list as an ordered factor following the AOU sequence.
# Joel will do this.



# 4/11/19 - JR - Question:
# is subsetting on Common_Name getting everything we want?
#
# Target Species AOU order: (using AOS 2018 data)
# FINISH EDITING - or put in Data_wrangling?

