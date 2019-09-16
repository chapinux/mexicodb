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


df2 <-  fread(opt$file,sep = ",")

df2 <-  df2 %>% filter(YEAR==2015)


#netoyage des colonnes inutiles

all(df2$COUNTRY == 484)
all(df2$YEAR == 2015)

df2$YEAR <-  NULL
df2$COUNTRY <- NULL

df2$GEO1_MX1990 <- NULL
df2$GEO1_MX1995 <- NULL
df2$GEO1_MX2000 <- NULL
df2$GEO1_MX2005 <- NULL
df2$GEO1_MX2010 <- NULL

df2$GEO2_MX1990 <- NULL
df2$GEO2_MX1995 <- NULL
df2$GEO2_MX2000 <- NULL
df2$GEO2_MX2005 <- NULL
df2$GEO2_MX2010 <- NULL

df2$V1 <- NULL

df2$GEO1_MX2015 <- NULL
df2$GEO2_MX2015 <- NULL

write.csv(df2, opt$out, row.names = F)
