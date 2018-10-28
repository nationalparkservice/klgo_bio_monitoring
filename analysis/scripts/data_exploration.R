# check dates and unit of first non-zero counts each year
# for each spp (relative to first survey date)
############
# This script uses library("dplyr") to wrangle species data.
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

library(dplyr)
library(lubridate)
library(tidyr)

species_data_names <-
  #combine species observation with species names
  left_join(species_datafrom_Excel, tlu_species_codes,
            by = c("Species" = "Code")) %>%

  #separate date and time
  #use lubridate pkg to create Date variable
  separate(Date, c("Date1", "Time"), sep = " ") %>%
  mutate(Date = mdy(Date1), Year = as.numeric(format(Date, "%Y"))) %>%

  select(Year, Date, `Survey Unit`, Species, `# Observed`,
         Category, Family, Common_Name) %>%
  filter(`# Observed`!=0) %>%
  group_by(Species) %>%
  arrange(Year) %>%
  #take first observation from each year
  filter(row_number()==1)

#to do: make row for # of days past first survey date?

#question: is
