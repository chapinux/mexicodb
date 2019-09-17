#!/usr/bin/env Rscript

suppressMessages(library(data.table))
suppressMessages(library(dplyr))
suppressMessages(library(optparse))

# Script option definition
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

df2$AGE2 <-  na_if(df2$AGE2, 99)
df2$SCHOOL <-  na_if(df2$SCHOOL, 0)
df2$LIT <-  na_if(df2$LIT, 0)
df2$EDATTAIN <-  na_if(df2$EDATTAIN, 0)
df2$EDATTAIND <-  na_if(df2$EDATTAIND, 000)
df2$YRSCHOOL <-  na_if(df2$YRSCHOOL, 99)
df2$EDUCMX <-  na_if(df2$EDUCMX, 999)
df2$MIGMX2 <-  na_if(df2$MIGMX2, 00)
df2$FLOOR <-  na_if(df2$FLOOR, 000)
df2$TOILET <-  na_if(df2$TOILET, 00)
df2$BEDROOMS <-  na_if(df2$BEDROOMS, 99)
df2$ROOMS <-  na_if(df2$ROOMS, 99)
df2$SEWAGE <-  na_if(df2$SEWAGE, 00)
df2$WATSUP <-  na_if(df2$WATSUP, 00)
df2$ELECTRIC <-  na_if(df2$ELECTRIC, 0)

write.csv(df2, opt$out, row.names = F)
