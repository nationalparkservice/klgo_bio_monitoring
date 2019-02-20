############
# This script uses libraries "dplyr", "lubridate", and "tidyr" to wrangle species data;
# and uses library "ggplot2" to visualize the data.
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

species_data <- left_join(tbl_Field_Data, tbl_Events,
                          by = "Event_ID") %>%
  left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  mutate(Date = substr(Start_Date, 1, 8),
         Date = mdy(Date),
         Month_Day = format(Date, "%m-%d")) %>%
  filter(`Num_ Observed` > 0, Year >= 2003) %>%
  group_by(Species, Year, Month_Day) %>%
  mutate(total_obs = sum(`Num_ Observed`)) %>%
  ungroup() #%>%
#ungroup() %>%
#group_by(Species, Year) %>%
#filter(row_number()==1) %>%
#ungroup() #%>%
#arrange()

species_top <- species_data %>%
  group_by(Species) %>%
  summarize(total = sum(total_obs)) %>%
  arrange(desc(total)) %>%
  top_n(n = 20, wt = total)

species_graph <- species_top %>%
  left_join(species_data,
            by = "Species")

ggplot(species_graph, aes(Common_Name, Month_Day)) +
  geom_point() +
  labs(title = "Bird Species Obs. by Date, 2003-2009",
       x = "Species",
       y = "Date") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete() +
  coord_flip() +
  theme_classic()

#what is the NA value on the graph?
#to do: arrange by first sighting,
#get breaks in x axis label

