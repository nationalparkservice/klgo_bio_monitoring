# Rectrieve Data when working on local windows machine
############
# This script uses library("odbc") to access the local MS ACCESS mdb file
# in the ../data/raw_data folder.
# ASSUMES
# - you are working on Windows machine using locally installed R and data files.
# - you are working on 32-bit version of R (so can use 32-bit drivers for odbc)
########
# Joel H. Reynolds, joel_reynolds@nps.gov
# Last Edit: 2018 Oct 5
########
# Misc. Notes on Background:
# on PC: Control Panel -> Admin -> ODBC Data Sources (64 bit)
# -> User DSN
#    only shows 32 bit drivers (dBASE files, Excel Files, MS Access Database [*mdb]).
# -> Drivers
#    shows 'SQL Server' with ref to a 32-bit dll.
# ==> suggests have to work in 32 bit version of R & Rstudio, etc.
# So in Rstudio, reset Global Options to 32-bit R.
# Added check (R.Version call below) that will stop if run on 64-bit version.
##########################################################

########## WARNING #################
# THIS SCRIPT IS INCOMPLETE        #
########## WARNING #################

# Check that using 32-bit R; if not, stop!
if (R.Version()$arch!="i386") {warning("Need to run on 32-bit R to access database");stop()}
### Modify to extract bit from sessionInfo()$platform via grep to get at XX in "(XX-bit)"


# add package
library("odbc");library("DBI");


# likely unuseful 32-bit solution since "odbcConnectAccess is only usable with 32-bit Windows"
library(RODBC)
db <- RODBC::odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};
                        DBQ=..\\data\\raw_data\\Coastal_Bird_Survey_Data.mdb")

# Get data
data <- as_tibble(sqlFetch (db , "Table or Query Name", rownames=TRUE))

###############
conn <- odbc::dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "localhost\\SQLEXPRESS",  #way to set to local machine
                 Database = "Coastal_Bird_Survey_Data.mdb",        # set to local
                 Trusted_Connection = "True")

conn <- odbc::dbConnect(RSQLite::SQLite(), path="../data/raw_data/Coastal_Bird_Survey_Data.mdb")

#create connection to the MDB file
conn <- RODBC::odbcConnectAccess("..\\data\\raw_data\\Coastal_Bird_Survey_Data.mdb", uid="", pwd="")

#check that connection has worked
sqlTables(conn)


### Using dbplyr package & odbc DBI backend
conn <-DBI::dbConnect(odbc::odbc(), path="../data/raw_data/Coastal_Bird_Survey_Data.mdb")

