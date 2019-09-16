#!/usr/bin/Rscript

https://www.rdocumentation.org/packages/R.utils/versions/2.9.0/topics/commandArgs

args = commandArgs(trailingOnly=TRUE)

library(data.table)
library(dplyr)
library(sf)


df2 <-  fread("/media/paulchapron/Data/Mexique_IGAST/mexico2015_NA_insteadof_NIU.csv")
names(df2)
str(df2)
head(df2)

# données contours 
mexicoshp <-  st_read("/media/paulchapron/Data/Mexique_IGAST/geo2_mx1960_2015/geo2_mx1960_2015.shp")
st_crs(mexicoshp)
names(mexicoshp)
mexicoshp$CNTRY_CODE <- NULL
mexicoshp$CNTRY_NAME <- NULL
plot(mexicoshp["GEOLEVEL2"], lwd=0.1)
names(mexicoshp)



## couverture des données
  varz <- c("ELECTRIC","WATSUP" , "SEWAGE"  , "ROOMS" ,  "BEDROOMS", "TOILET" ,  "FLOOR"  ,  "PERNUM",    
 "PERWT"  , "RELATE" ,  "RELATED" , "AGE" ,   "AGE2"  , "SEX" , "SCHOOL", "LIT", "EDATTAIN" , "EDATTAIND" , "YRSCHOOL"  , "EDUCMX"   ,"MIGMX2"  ) 
dfEffectif_by_GEO2 <-  df2 %>% 
  group_by(GEO2_MX) %>% 
 summarise(effectif=n()) 

dfMissing_by_GEO2 <- 
  df2 %>%
  group_by(GEO2_MX)%>% 
  summarise_at(varz,funs(sum(is.na(.)))) 

dfMissing <-  merge(dfEffectif_by_GEO2, dfMissing_by_GEO2)

rm(dfEffectif_by_GEO2)

dfMissing <-  dfMissing %>% 
  mutate_at(varz, funs(./effectif))

mexicoMissingValues <-  merge(mexicoshp, dfMissing,  by.x="GEOLEVEL2" , by.y="GEO2_MX")


# carto du pourcentage de NA 
setwd("/media/paulchapron/Data/Mexique_IGAST/maps/")
mapMissing <- function(currentVar){
  mapName <-  paste0("MissingValues_", currentVar)
png(filename = paste0(mapName, ".png"), width=1400, height = 800)
  plot(mexicoMissingValues[currentVar], main=paste0("Proportions de données NA pour la variable ", currentVar))
  dev.off()
}
sapply(varz, mapMissing)





#df age trié par id de geo2
dfAGE_byGEO2 <-  df2 %>% 
  group_by(GEO2_MX) %>% 
  summarise(meanAGE = mean(AGE,na.rm = T), weightedMeanAGE = weighted.mean(AGE,HHWT, na.rm = T),sdAGE=sd(AGE,na.rm = T), medianAGE=median(AGE,na.rm = T)) 

mexicoshpAGE <-  merge(mexicoshp, dfAGE_byGEO2, by.x="GEOLEVEL2" , by.y="GEO2_MX") 
names(mexicoshpAGE)


#carto âge moyen
plot(mexicoshpAGE["weightedMeanAGE"], main = "Age moyen par région", lwd=0.2)



df2$YRSCHOOL

#df années d'études trié par id de geo2
dfYRS_byGEO2 <-  df2 %>% 
    filter(YRSCHOOL < 90) %>% 
    group_by(GEO2_MX) %>% 
  summarise(meanYRs = mean(YRSCHOOL,na.rm = T), wtMean = weighted.mean(YRSCHOOL,HHWT, na.rm = T),sdAGE=sd(YRSCHOOL,na.rm = T), medAGE=median(YRSCHOOL,na.rm = T)) 

mexicoshpYRS <-  merge(mexicoshp, dfYRS_byGEO2, by.x="GEOLEVEL2" , by.y="GEO2_MX") 

#carto âge moyen
plot(mexicoshpYRS["wtMean"], main = "nombre d'années d'étude moyen par région", lwd=0.2)









