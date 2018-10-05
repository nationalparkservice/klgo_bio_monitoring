# Rectrieve Data when working on local windows machine
############
# This script uses library("RJDBC") to access the local MS ACCESS mdb file
# in the ../data/raw_data folder.
# ASSUMES you are working on Windows machine using locally installed R and data files.
########
# Joel H. Reynolds, joel_reynolds@nps.gov
# Last Edit: 2018 Oct 5
########

########## WARNING #################
# THIS SCRIPT IS INCOMPLETE        #
########## WARNING #################


# add package
library("RODBC","odbc")

#create connection to the MDB file
conn <- odbcConnectAccess("../data/raw_data/Coastal_Bird_Survey_Data.mdb")

#check that connection has worked
sqlTables(conn)


### Using dbplyr package & odbc DBI backend
conn <-DBI::dbConnect(odbc::odbc(), path="../data/raw_data/Coastal_Bird_Survey_Data.mdb")

