# title
############
# This script examines the time duration at each site by day and year.
########
# Madeleine Ward
# Last Edit: 2018 Oct 30
########

#TO DO: ACCOUNT FOR DECIMAL FORMATS -
#if/else
#ex. some problematic times below
new <- species_datafrom_Excel[375:419,]

times <- species_datafrom_Excel$Begin
times[377]
times_converted <- sub("(\\d+)(\\d{2})", "\\1:\\2", times)
times_converted

#this code finds duration time-wise for dates/units
time_duration <- species_datafrom_Excel %>%
  distinct(Date, `Survey Unit`, .keep_all = TRUE) %>%
  mutate(start_time = sub("(\\d+)(\\d{2})", "\\1:\\2", Begin),
         end_time = sub("(\\d+)(\\d{2})", "\\1:\\2", End))#,
         #duration = difftime(end_time, start_time,
          #                   units = c("mins")))

 # select(Date, `Survey Unit`, )
