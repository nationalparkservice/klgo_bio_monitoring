# Retrieve CSV Data when working on swarthmore R server
############
# This script uses library("readr") to access the comma-separated files associated with species data.
########
# Madeleine Ward
# Last Edit: 2018 Oct 17
########

print(getwd()) # JR added 2019 Feb 5 to help traceback

#path = "./analysis/data/raw_data/CSVs/"
path = "../data/raw_data/CSVs/"  #JR corrected 2019 Feb 5


#retrieve file names with full path included
file_names <- dir(path, full.names = TRUE)

for(i in 1:length(file_names)){

  #remove path and .csv from tibble name
  title <- gsub(".*/", "", file_names[i])
  title <- gsub(".csv", "", title)

  #assign tibble names to data frames
  assign(title, read_csv(file_names[i]))
}
