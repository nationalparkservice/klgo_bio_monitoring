# Retrieve CSV Data when working on swarthmore R server
############
# This script uses library("readr") to access the comma-separated files associated with species data.
########
# Madeleine Ward
# Last Edit: 2018 Oct 17
########

path = "./analysis/data/raw_data/CSVs/"
file_names <- dir(path)
library(readr)
for(i in 1:length(file_names)){
  print(file_names[i])
  read_csv(file_names[i]) #this gets an error
}
