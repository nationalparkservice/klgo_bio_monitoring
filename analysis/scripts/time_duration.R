# title
############
# This script examines the time duration at each site by day and year.
########
# Madeleine Ward
# Last Edit: 2018 Oct 30
########

# title
############
# This script examines the time duration at each site by day and year
########
# Madeleine Ward
# Last Edit: 2018 Oct 30
########

#TO DO: ACCOUNT FOR DECIMAL FORMATS -
#if/else
#ex. some problematic times below
new <- tbl_Field_Data[375:419,]

times <- tbl_Field_Data$Begin
times[377]
times_converted <- sub("(\\d+)(\\d{2})", "\\1:\\2", times)
times_converted

library(chron)
#x <- chron(times=time)

#this code finds duration time-wise for dates/units
time_duration <- tbl_Field_Data %>%
  left_join(tbl_Events,
            by = "Event_ID") %>%
  left_join(tbl_Locations,
            by = "Location_ID") %>%
  mutate(time_start = substr(Start_Time, 10, 17),
         time_end = substr(End_Time, 10, 17),
         Date = substr(Start_Date, 1, 8),
         Date = mdy(Date),
         time_start = chron(times=time_start),
         time_end = chron(times=time_end)) %>%
  distinct(Date, GIS_Location_ID, .keep_all = TRUE) %>%
  filter(GIS_Location_ID == "Site 1")

library(ggalt)
ggplot(time_duration, aes(x = time_start,
                          xend = time_end,
                          y = Date,
                          group = Date)) +
  geom_dumbbell(#color="#a3c4dc",
    #size=0.75,
    #point.colour.l="#0e668b"
  ) #+
scale_x_continuous(label=percent) +
  labs(x=NULL,
       y=NULL,
       title="Dumbbell Chart",
       subtitle="Pct Change: 2013 vs 2014",
       caption="Source: https://github.com/hrbrmstr/ggalt") +
  theme(plot.title = element_text(hjust=0.5, face="bold"),
        plot.background=element_rect(fill="#f7f7f7"),
        panel.background=element_rect(fill="#f7f7f7"),
        panel.grid.minor=element_blank(),
        panel.grid.major.y=element_blank(),
        panel.grid.major.x=element_line(),
        axis.ticks=element_blank(),
        legend.position="top",
        panel.border=element_blank())

#%>%
mutate(start_time = sub("(\\d+)(\\d{2})", "\\1:\\2", Begin),
       end_time = sub("(\\d+)(\\d{2})", "\\1:\\2", End))#,
#duration = difftime(end_time, start_time,
#                   units = c("mins")))

# select(Date, `Survey Unit`, )
