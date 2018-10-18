library(readr)
species_data <- read_csv("./analysis/data/raw_data/CSVs/copy_of_species_data.csv")

library(dplyr)
library(tidyr)
tlu_species_codes <- read_csv("./analysis/data/raw_data/CSVs/tlu_species_codes.csv")
species_data_names <- left_join(species_data, tlu_species_codes, by = c("Species" = "Code")) %>%
  separate(Date, c("Date", "Time"), sep = " ") %>%
  select(-Time)
