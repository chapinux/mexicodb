library(data.table)
library(dplyr)
library(sf)

#   start_timeFread <- Sys.time()
#   df2 <-  fread("/media/paulchapron/Data/Mexique_IGAST/ipumsi_00028.csv",sep = ",")
#   end_timeFread <- Sys.time()
#  
#  df2 <-  df2 %>% filter(YEAR==2015)
#  
#  
# #netoyage des colonnes inutiles
# 
#  all(df2$COUNTRY == 484)
#  all(df2$YEAR == 2015)
# 
#  df2$YEAR <-  NULL
#  df2$COUNTRY <- NULL
# 
#  df2$GEO1_MX1990 <- NULL
#  df2$GEO1_MX1995 <- NULL
#  df2$GEO1_MX2000 <- NULL
#  df2$GEO1_MX2005 <- NULL
#  df2$GEO1_MX2010 <- NULL
# 
# 
#  df2$GEO2_MX1990 <- NULL
#  df2$GEO2_MX1995 <- NULL
#  df2$GEO2_MX2000 <- NULL
#  df2$GEO2_MX2005 <- NULL
#  df2$GEO2_MX2010 <- NULL
# 
#  df2$V1 <- NULL
# 
# head(df2)
# 
# 
#  df2$GEO1_MX2015 <- NULL
#  df2$GEO2_MX2015 <- NULL
# 
#  write.csv(df2,"/media/paulchapron/Data/Mexique_IGAST/mexico2015.csv", row.names = F)


 
 

 #####################
## valeurs manquantes (NIU, 999) etc
 #####################
 
 
#  df2 <-  fread("/media/paulchapron/Data/Mexique_IGAST/mexico2015.csv",na.strings = "NIU")
# 
# 
# df2 %>% filter(AGE2==99) %>%  nrow()
# df2$AGE2 <-  na_if(df2$AGE2, 99)
# df2 %>% filter(AGE2==99) %>%  nrow()
# 
# df2 %>% filter(SCHOOL==0) %>%  nrow()
# df2$SCHOOL <-  na_if(df2$SCHOOL, 0)
# df2 %>% filter(SCHOOL==0) %>%  nrow()
# 
# df2 %>% filter(LIT==0) %>%  nrow()
# df2$LIT <-  na_if(df2$LIT, 0)
# df2 %>% filter(LIT==0) %>%  nrow()
# 
# df2 %>% filter(EDATTAIN==0) %>%  nrow()
# df2$EDATTAIN <-  na_if(df2$EDATTAIN, 0)
# df2 %>% filter(EDATTAIN==0) %>%  nrow()
# 
# df2 %>% filter(EDATTAIND==000) %>%  nrow()
# df2$EDATTAIND <-  na_if(df2$EDATTAIND, 000)
# df2 %>% filter(EDATTAIND==000) %>%  nrow()
# 
# df2 %>% filter(YRSCHOOL==99) %>%  nrow()
# df2$YRSCHOOL <-  na_if(df2$YRSCHOOL, 99)
# df2 %>% filter(YRSCHOOL==99) %>%  nrow()
# 
# df2 %>% filter(EDUCMX==999) %>%  nrow()
# df2$EDUCMX <-  na_if(df2$EDUCMX, 999)
# df2 %>% filter(EDUCMX==999) %>%  nrow()
# 
# df2 %>% filter(MIGMX2==00) %>%  nrow()
# df2$MIGMX2 <-  na_if(df2$MIGMX2, 00)
# df2 %>% filter(MIGMX2==00) %>%  nrow()
# 
# df2 %>% filter(FLOOR==000) %>%  nrow()
# df2$FLOOR <-  na_if(df2$FLOOR, 000)
# df2 %>% filter(FLOOR==000) %>%  nrow()
# 
# df2 %>% filter(TOILET==00) %>%  nrow()
# df2$TOILET <-  na_if(df2$TOILET, 00)
# df2 %>% filter(TOILET==00) %>%  nrow()
# 
# df2 %>% filter(BEDROOMS==99) %>%  nrow()
# df2$BEDROOMS <-  na_if(df2$BEDROOMS, 99)
# df2 %>% filter(BEDROOMS==99) %>%  nrow()
# 
# df2 %>% filter(ROOMS==99) %>%  nrow()
# df2$ROOMS <-  na_if(df2$ROOMS, 99)
# df2 %>% filter(ROOMS==99) %>%  nrow()
# 
# df2 %>% filter(SEWAGE==00) %>%  nrow()
# df2$SEWAGE <-  na_if(df2$SEWAGE, 00)
# df2 %>% filter(SEWAGE==00) %>%  nrow()
# 
# df2 %>% filter(WATSUP==00) %>%  nrow()
# df2$WATSUP <-  na_if(df2$WATSUP, 00)
# df2 %>% filter(WATSUP==00) %>%  nrow()
# 
# df2 %>% filter(ELECTRIC==0) %>%  nrow()
# df2$ELECTRIC <-  na_if(df2$ELECTRIC, 0)
# df2 %>% filter(ELECTRIC==0) %>%  nrow()


# write.csv(df2,"/media/paulchapron/Data/Mexique_IGAST/mexico2015_NA_insteadof_NIU.csv", row.names = F)


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
varz
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









