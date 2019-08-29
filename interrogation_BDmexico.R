library(dbplyr)
library(RPostgreSQL)
library(sf)
library(dbplyr)


user <-  "m2igast"
pwd_en_clair <-  ""


dridri <-  DBI::dbDriver("PostgreSQL")

connec <- dbConnect(dridri, dbname="mexico", 
                    user=user, 
                    password=pwd_en_clair, 
                    host = "localhost", 
                    port = 5432)




df1 <-  data.frame(V1= rnorm(20), V2= rnorm(20))

dbCreateTable(connec, name = "tutu", fields =df1 )
dbGetQuery(connec, "SELECT * from tutu ;")
dbWriteTable(connec, "tutu", value = df1, append=T)
dbRemoveTable(connec, "tutu")

df2
