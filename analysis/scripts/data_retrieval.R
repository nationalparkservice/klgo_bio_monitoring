#data retrieval code using JDBC
#library: download "UCanAccess" from this site: http://ucanaccess.sourceforge.net/site.html#home
  #upload zipped file to RStudio
library("RJDBC")
#create JDBC driver
drv <- JDBC("net.ucanaccess.jdbc.UcanaccessDriver",c("~/UCanAccess-4.0.4-bin/ucanaccess-4.0.4.jar","~/UCanAccess-4.0.4-bin/lib/jackcess-2.1.11.jar","~/UCanAccess-4.0.4-bin/lib/commons-lang-2.6.jar","~/UCanAccess-4.0.4-bin/lib/commons-logging-1.1.3.jar","~/UCanAccess-4.0.4-bin/lib/hsqldb.jar"))
#create connection
conn <- dbConnect(drv,"jdbc:ucanaccess:///"path to file"")

#check that connection has worked
dbListTables(conn)
