#Value of all units - only some spp in unit X?; “unit by species occurrence” relationships?
############
#
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

tbl_Locations$GIS_Location_ID <- str_sub(tbl_Locations$GIS_Location_ID,start=-1)

species_units <-
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
  left_join(tlu_species_codes, by = c("Species" = "Code"))# %>%
#optional: spread command
  #spread(GIS_Location_ID, total_Observed)

#to do: make plot
plot4 <- ggplot(species_units, aes(as.numeric(Days_since_first),
                          total_Observed,
                          color = as.factor(Year))) +
  geom_jitter(height = .3, aes(fill = GIS_Location_ID)) +
  #in ggforce package to supposedly distribute facets over pages
  facet_wrap_paginate(~Species, ncol = 1, scales = "free") +
  ylim(c(0, 2000))
print(plot4)

#how to
  #1. order bars with a y aesthetic,
  #2. have species not take up so much space
  #3. get rid of 0/NA values to take up less space?? ("free_x" not working)
plot5 <- ggplot(species_units, aes(Species, total_Observed, fill = as.factor(Year))) +
  geom_bar(stat = "identity") +
  coord_flip() +
  #in ggforce package to supposedly distribute facets over pages
  facet_wrap_paginate(~GIS_Location_ID, ncol = 2, scales = "free")
print(plot5)
#bar chart:
  #faceted by unit (8) and by non-zero species?
  #x = all species(?), could be separated by year
  #y = total number observed in that year
  #flip scale, arranged in descending
