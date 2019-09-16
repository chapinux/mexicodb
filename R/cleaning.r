#!/usr/bin/env Rscript

suppressMessages(library(data.table))
suppressMessages(library(dplyr))
suppressMessages(library(optparse))

args_list <- list(
	  make_option(
		c("-f", "--file"),
		type="character",
		default=NULL,
		help="IPUMS dataset file",
		metavar="character"),
	make_option(
		c("-o", "--output"),
		type="character",
		default=NULL,
		help="output file",
		metavar="character")
)

opt_parser <- OptionParser(option_list=args_list)
opt <- parse_args(opt_parser)

########################################
## valeurs manquantes (NIU, 999) etc  ##
########################################
 
 
df2 <- fread(opt$file, na.strings = "NIU")


df2 %>% filter(AGE2==99) %>%  nrow()
df2$AGE2 <-  na_if(df2$AGE2, 99)
df2 %>% filter(AGE2==99) %>%  nrow()

df2 %>% filter(SCHOOL==0) %>%  nrow()
df2$SCHOOL <-  na_if(df2$SCHOOL, 0)
df2 %>% filter(SCHOOL==0) %>%  nrow()

df2 %>% filter(LIT==0) %>%  nrow()
df2$LIT <-  na_if(df2$LIT, 0)
df2 %>% filter(LIT==0) %>%  nrow()

df2 %>% filter(EDATTAIN==0) %>%  nrow()
df2$EDATTAIN <-  na_if(df2$EDATTAIN, 0)
df2 %>% filter(EDATTAIN==0) %>%  nrow()

df2 %>% filter(EDATTAIND==000) %>%  nrow()
df2$EDATTAIND <-  na_if(df2$EDATTAIND, 000)
df2 %>% filter(EDATTAIND==000) %>%  nrow()

df2 %>% filter(YRSCHOOL==99) %>%  nrow()
df2$YRSCHOOL <-  na_if(df2$YRSCHOOL, 99)
df2 %>% filter(YRSCHOOL==99) %>%  nrow()

df2 %>% filter(EDUCMX==999) %>%  nrow()
df2$EDUCMX <-  na_if(df2$EDUCMX, 999)
df2 %>% filter(EDUCMX==999) %>%  nrow()

df2 %>% filter(MIGMX2==00) %>%  nrow()
df2$MIGMX2 <-  na_if(df2$MIGMX2, 00)
df2 %>% filter(MIGMX2==00) %>%  nrow()

df2 %>% filter(FLOOR==000) %>%  nrow()
df2$FLOOR <-  na_if(df2$FLOOR, 000)
df2 %>% filter(FLOOR==000) %>%  nrow()

df2 %>% filter(TOILET==00) %>%  nrow()
df2$TOILET <-  na_if(df2$TOILET, 00)
df2 %>% filter(TOILET==00) %>%  nrow()

df2 %>% filter(BEDROOMS==99) %>%  nrow()
df2$BEDROOMS <-  na_if(df2$BEDROOMS, 99)
df2 %>% filter(BEDROOMS==99) %>%  nrow()

df2 %>% filter(ROOMS==99) %>%  nrow()
df2$ROOMS <-  na_if(df2$ROOMS, 99)
df2 %>% filter(ROOMS==99) %>%  nrow()

df2 %>% filter(SEWAGE==00) %>%  nrow()
df2$SEWAGE <-  na_if(df2$SEWAGE, 00)
df2 %>% filter(SEWAGE==00) %>%  nrow()

df2 %>% filter(WATSUP==00) %>%  nrow()
df2$WATSUP <-  na_if(df2$WATSUP, 00)
df2 %>% filter(WATSUP==00) %>%  nrow()

df2 %>% filter(ELECTRIC==0) %>%  nrow()
df2$ELECTRIC <-  na_if(df2$ELECTRIC, 0)
df2 %>% filter(ELECTRIC==0) %>%  nrow()


write.csv(df2, opt$out, row.names = F)