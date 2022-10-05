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

# save all tif files as dataframe in a list
list_files_name_temp = list.files(path = path,
                  pattern = "*.tif")

precipitation_list_file = list()
for(i in 1:length(list_files_name_temp)){
    filename = list_files_name_temp[i]
    r = raster(paste(path,
                     filename,
                     sep = "/"))
    df = as.data.frame(r, xy = TRUE)
    precipitation_list_file[[i]] = df
}

# save list of files for each month
save(precipitation_list_file,
     file = "processedData/precipitation_list_file.rda")




######## Min Tempreature (2.5 minutes) ##########
path = "Data/min_temperature"
url = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmin.zip"
filename = "wc2.1_2.5m_tmin.zip"
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

# save all tif files as dataframe in a list
list_files_name_min = list.files(path = path,
                             pattern = "*.tif")

min_temperature_list_file = list()
for(i in 1:length(list_files_name_min)){
    filename = list_files_name_min[i]
    r = raster(paste(path,
                     filename,
                     sep = "/"))
    df = as.data.frame(r, xy = TRUE)
    min_temperature_list_file[[i]] = df
}

# save list of files for each month
save(min_temperature_list_file,
     file = "processedData/min_temperature_list_file.rda")



######## Max Tempreature (2.5 minutes) ##########
path = "Data/max_temperature"
url = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmax.zip"
filename = "wc2.1_2.5m_tmax.zip"
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

# save all tif files as dataframe in a list
list_files_name_max = list.files(path = path,
                                 pattern = "*.tif")

max_temperature_list_file = list()
for(i in 1:length(list_files_name_max)){
    filename = list_files_name_max[i]
    r = raster(paste(path,
                     filename,
                     sep = "/"))
    df = as.data.frame(r, xy = TRUE)
    max_temperature_list_file[[i]] = df
}

# save list of files for each month
save(max_temperature_list_file,
     file = "processedData/max_temperature_list_file.rda")


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

# save all tif files as dataframe in a list
list_files_name_avg = list.files(path = path,
                                 pattern = "*.tif")

avg_temperature_list_file = list()
for(i in 1:length(list_files_name_avg)){
    filename = list_files_name_avg[i]
    r = raster(paste(path,
                     filename,
                     sep = "/"))
    df = as.data.frame(r, xy = TRUE)
    avg_temperature_list_file[[i]] = df
}

# save list of files for each month
save(avg_temperature_list_file,
     file = "processedData/avg_temperature_list_file.rda")




######## Geolocalized Economic Data ##########
# Geophysically scaled dataset linking per capita gross product (GDP) at purchasing power parity (PPP) rates
path = "Data"
url = "http://gecon.yale.edu/sites/default/files/files/Gecon40_post_final.xls"
filename = "Gecon40_post_final.xls"
destfile = paste(getwd(),
                 path,
                 filename,
                 sep = "/")

# download zip file
if(!file.exists(destfile)){
    download.file(url = url,
                  destfile = destfile)
}

# read the file
gEcon = read_excel("Data/Gecon40_post_final.xls")
PPP <- read_excel("Data/Gecon40_post_final.xls",sheet = 1)
#Gross cell product, 2005 US $ at purchasing power parity exchange rates, 2005 - column PPP2005_40 in GEcon40-Table 1.csv
PPP <-PPP[,c(14,13,29)]
RPP <- rasterFromXYZ(PPP)
plot(RPP)
RPP <- resample(RPP, aegypti.data, method='ngb')

GDP <- RPP*exp(0.47362)
# save list of files for each month
save(gEcon,
     file = "processedData/gEcon.rda")





######## Global Aedes Distribution ##########
# Uncertainty estimates for mosquito distribution at 5 km x 5 km resolution
path = "Data"
url = "https://www.dropbox.com/sh/bpxcmzmmpiiav8u/AAAl3CBKnBYwXb0n1s1C4-K-a?dl=0&preview=aegypti.tif"
filename = "aegypti.tif"
destfile = paste(getwd(),
                 path,
                 filename,
                 sep = "/")

# download zip file
if(!file.exists(destfile)){
    download.file(url = url,
                  destfile = destfile)
}


r = raster(paste(path, filename, sep = "/"))
aegypti = as.data.frame(r, xy = TRUE)

# save list of files for each month
save(aegypti,
     file = "processedData/aegypti.rda")




######## Human Population Density ##########
# We will use the Unconstrained individual countries2000-2020 UN adjusted (1 km resolution). This will
# need to be changed to match the 5 km x 5 km resolution of the other data sets.
path = "Data"
url = "https://www.dropbox.com/sh/bpxcmzmmpiiav8u/AAAl3CBKnBYwXb0n1s1C4-K-a?dl=0&preview=aegypti.tif"
filename = "aegypti.tif"
destfile = paste(getwd(),
                 path,
                 filename,
                 sep = "/")

# download zip file
if(!file.exists(destfile)){
    download.file(url = url,
                  destfile = destfile)
}


r = raster(paste(path, filename, sep = "/"))
aegypti = as.data.frame(r, xy = TRUE)

# save list of files for each month
save(aegypti,
     file = "processedData/aegypti.rda")
