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

## @knitr data_before_2007

#species_before_2007 <-
  #combine species observation with species names
  #left_join(species_datafrom_Excel, tlu_species_codes,
            #by = c("Species" = "Code")) %>%

  #separate date and time
  #use lubridate pkg to create Date variable
  #separate(Date, c("Date1", "Time"), sep = " ") %>%
  #mutate(Date = mdy(Date1), Year = as.numeric(format(Date, "%Y"))) %>%

  #select(Year, Date, `Survey Unit`, Species, `# Observed`,
         #Category, Family, Common_Name) %>%
  #filter(`# Observed`!=0) %>%
  #group_by(Species) %>%
  #arrange(Year) %>%

  #take first observation from each year
  #filter(row_number()==1)

#to do: make row for # of days past first survey date?


## @knitr data2007
species_data_2007 <- left_join(tbl_Field_Data, tbl_Events,
                               by = "Event_ID") %>%
  left_join(tlu_species_codes,
            by = c("Species" = "Code")) %>%
  separate(Start_Date, c("Date", "Time_0"), sep = " ") %>%
  separate(Start_Time, c("Date_01", "Time_Start"), sep = " ") %>%
  #how to fit all these into one argument??
  separate(End_Time, c("Date_02", "Time_End"), sep = " ") %>%
  mutate(Date = mdy(Date),
         Day_Month = format(Date, "%m-%d")) %>%
  filter(`Num_ Observed` != 0, Year >= 2003) %>%
  group_by(Year) %>%
  arrange(Date) %>%
  mutate(Days_since_first = Date - Date[row_number()==1]) %>%
  ungroup() %>%

  group_by(Species) %>%
  arrange(Year) #%>%

  #take first observation from each year
  #filter(row_number()==1)

species_data_2007$type <-
ifelse(species_data_2007$`Num_ Observed` < mean(species_data_2007$`Num_ Observed`), "below", "above")

#unfinished
plot <- ggplot(species_data_2007, aes(x=as.factor(Days_since_first), y=`Num_ Observed`)) +
  geom_bar(stat='identity', aes(fill = as.factor(Year))) +
  labs(title="Ordered Bar Chart",
       subtitle="Make Vs Avg. Mileage",
       caption="source: mpg") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
  facet_wrap(~Species)

for (i in seq(1, length(unique(species_data_2007$Species)), 6)) {
  print(plot)
}
