# Retrieve CSV Data when working on swarthmore R server
############
# Read in the comma-separated files associated with species data.
########
# Libraries used: readr
########
# Madeleine Ward
# Last Edit: 2018 Oct 17
########

#path = "./analysis/data/raw_data/CSVs/"
path = "../data/raw_data/CSVs/"  #JR corrected 2019 Feb 5


#retrieve file names with full path included
file_names <- dir(path, full.names = TRUE)

for(i in 1:length(file_names)){

  #remove path and .csv from tibble name
  title <- gsub(".*/", "", file_names[i])
  title <- gsub(".csv", "", title)

  #assign tibble names to data frames
  assign(title, suppressMessages(read_csv(file_names[i])))
}
