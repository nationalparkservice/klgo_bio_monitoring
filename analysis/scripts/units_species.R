#Value of all units - only some spp in unit X?; “unit by species occurrence” relationships?
############
#
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

library(stringr)


tbl_Locations$GIS_Location_ID <- str_sub(tbl_Locations$GIS_Location_ID,start=-1)

species_units <-
  left_join((species_datafrom_Excel <-
               mutate(species_datafrom_Excel,
                      survey_unit = as.character(`Survey Unit`))),
            tbl_Locations,
            by = c("survey_unit" = "GIS_Location_ID")) %>%
  group_by(survey_unit, Species) %>%
  summarize(total_Observed = sum(`# Observed`)) %>%
  left_join(tlu_species_codes, by = c("Species" = "Code")) %>%
  spread(survey_unit, total_Observed)

#to do: change to naming conventions
#to do: make plot?
