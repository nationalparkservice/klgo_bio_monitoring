# check dates and unit of first non-zero counts each year
# for each spp (relative to first survey date)
############
# This script uses libraries "dplyr", "lubridate", and "tidyr" to wrangle species data;
# and uses library "ggplot2" to visualize the data.
########
# Madeleine Ward
# Last Edit: 2018 Oct 22
########

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

#species_data_2007$type <-
#ifelse(species_data_2007$`Num_ Observed` < mean(species_data_2007$`Num_ Observed`), "below", "above")

#faceted by species?
plot1 <- ggplot(species_data_2007 %>% ungroup() %>% filter(Species < "AMPI"),
       aes(as.factor(Days_since_first),
           `Num_ Observed`)) +
  geom_bar(stat='identity', aes(fill = as.factor(Year))) +
  #theme(axis.text.x = element_text(angle=65, vjust=0.6)) +
  #paginate
  facet_wrap_paginate(~Species, ncol = 1)

print(plot1)

#another way to paginate
#for (i in seq(1, length(unique(species_data_2007$Species)), 6)) {
 # print(plot)
#}

#first count every year?
plot2 <- ggplot(species_data_2007 %>%
         ungroup() %>%
         group_by(Species, Year) %>%
         arrange(Days_since_first) %>%
         top_n(1), aes(as.numeric(Days_since_first),
               `Num_ Observed`,
               color = as.factor(Year))) +
  #using facet_wrap_paginate() from ggforce
  #to distribute over pages
  facet_wrap_paginate(~Species, ncol = 1)
print(plot2)

#time series?
#dot plot
plot3 <- ggplot(species_data_2007, aes(as.factor(Year), `Num_ Observed`)) +
  geom_boxplot() +
  geom_dotplot(#binaxis='y',
               #stackdir='center',
               #dotsize = .5,
               #fill="red"
    )
print(plot3)
