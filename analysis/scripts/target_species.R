# Select data from target species from field dataset
########
# Libraries used: dplyr
########
# Madeleine Ward
# Last Edit: 2019 Feb 23
########

#create vector of target species types
targetList <- c("loon", "grebe", "cormorant", "eron", "duck", "goose", "plover", "sandpiper", "gull", "alcid", "kingfisher")

#use data frame species_data from data_wrangling.R
target_data <- species_data %>%
  #filter for species in targetList
  filter(str_detect(str_to_lower(Common_Name, locale = "en"), paste(targetList, collapse="|")))