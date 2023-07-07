# load libraris
library(dplyr)
library(raster)
library(ggplot2)
library(readxl)


# download datasets
# Globa Climate Datasets (https://worldclim.org/data/worldclim21.html)
# This is WorldClim version 2.1 climate data for 1970-2000. This version was released in January 2020.

######## precipitation (2.5 minutes) ##########
path = "Data/precipitation"
url = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_prec.zip"
filename = "wc2.1_2.5m_prec.zip"
destfile = paste(getwd(),
                 path,
                 filename,
                 sep = "/")

# download zip file
if(!file.exists(destfile)){
    download.file(url = url,
                  destfile = destfile)
}

# unzip file
unzip(destfile,
      exdir = path)


######## avg Tempreature (2.5 minutes) ##########
path = "Data/avg_temperature"
url = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tavg.zip"
filename = "wc2.1_2.5m_tavg.zip"
destfile = paste(getwd(),
                 path,
                 filename,
                 sep = "/")

# download zip file
if(!file.exists(destfile)){
    download.file(url = url,
                  destfile = destfile)
}

# unzip file
unzip(destfile,
      exdir = path)