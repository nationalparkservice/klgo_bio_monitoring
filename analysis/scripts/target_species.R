### DEPRACATED. SEE data_wrangling.R 3/2/20
##########################################
# Subset out data on target species from field dataset
########
# Libraries used: dplyr
########
# Madeleine Ward
# Last Edit:2020 Feb 27 Joel Reynolds updated targetList to capture desired families,
#                       order by AOU species ID, and partition into more manageable
#                       subsets for plots
#           2019 Feb 23, 2019 Aug 12 added survey_duration creation
########

##### List of Spp categorized as 'Waterbird'
#use data frame species_data from data_wrangling.R
# extract from species_data, remove duplicates, sort by taxonomic ID
# (which seems to reflect AOU ordering)
# 82 spp total
targetList <- species_data %>% filter(Category=="Waterbird") %>%
  select(Species, ID, Family, Common_Name, Latin_Name, Latin_Code) %>%
  distinct() %>% arrange(ID)


target_data <- species_data %>% filter(Category=="Waterbird")

#Ways to usefully partition spp for displays

target_data %>% select(Species, ID, Family, Common_Name, Latin_Name, Latin_Code) %>%
  distinct() %>% count(Family)

target_data %>% select(Species, ID, Family, Common_Name, Latin_Name, Latin_Code) %>%
  group_by(Family) %>% distinct(Common_Name) %>% arrange(Common_Name) %>% arrange(Family) %>% as.data.frame

# n= 4+2+11+1+1=19 Loons, Grebes, Gulls, Kingfisher, Heron
targetData1 <- target_data %>% filter(Family %in% c("Gaviidae","Podicipedidae","Laridae","Alcedinidae","Ardeidae"))

#n = 34 Ducks and Geese
targetData2 <- target_data %>% filter(Family %in% c("Anatidae"))

# n = 4, Alcidae
targetData3 <- target_data %>% filter(Family %in% c("Alcidae"))

# n = 25 Shorebirds
targetData4 <- target_data[is.na(target_data$Family),]


#Family            n
# 1 Alcedinidae       1 Kingfisher
# 2 Alcidae           4 Pigeon Guillemot, Marbled Murrelet, Thick-billed Murre, Tufted Puffin
# 3 Anatidae         34 ducks & geese
# 4 Ardeidae          1 GBH
# 5 Gaviidae          4 Loons: Common, Red-throated, Pacific, Yellow-billed
# 6 Laridae          11 Gulls: Herring, Bonaparte's, Glaucous-winged, Mew, Arctic Tern, Unidentified Larus Gull, Thayer's, Ring-billed, Glaucous, Black-legged Kittiwake, Caspian Tern
# 7 Podicipedidae     2 Red-necked Grebe, Horned Grebe
# 8 NA               25 shorebirds of various families



