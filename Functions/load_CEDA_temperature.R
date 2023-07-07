
# load libraries
library(ncdf4)
library(dplyr)
library(reshape2)


# open netCDF file teperature
nc_temp = nc_open("Data/cru_ts4.06.1901.2021.tmp.dat.nc")

# get the variable names
names(nc_temp$var)
names(nc_temp$dim)

# set the variables names
x = "lon"
y = "lat"
t = "time"

# get longitude, latitude and time
lon <- sort(ncvar_get(nc_temp,x))
lat <- sort(ncvar_get(nc_temp,y))
time <- ncvar_get(nc_temp,t)

# Convert numeric time values to date format
date <- as.Date("1900-01-01") + (time - 1)

# get Temperature
temp_array <- ncvar_get(nc_temp, "tmp")
dim(temp_array)

# extract some information from file 
fullname <- ncatt_get(nc_temp,"tmp","long_name")
dunits <- ncatt_get(nc_temp,"tmp","units")
title <- ncatt_get(nc_temp,0,"title")
institution <- ncatt_get(nc_temp,0,"institution")
datasource <- ncatt_get(nc_temp,0,"source")
references <- ncatt_get(nc_temp,0,"references")
history <- ncatt_get(nc_temp,0,"history")
Conventions <- ncatt_get(nc_temp,0,"Conventions")

# replace netCDF fill values with NA's
fillvalue <- ncatt_get(nc_temp,"tmp","_FillValue")
temp_array[temp_array==fillvalue$value] <- NA

# close the file
nc_close(nc_temp)

# Reshape the array to a long format
long_temp <- melt(temp_array)

# Rename the columns
colnames(long_temp) <- c("Longitude", "Latitude", "Date", "Temperature")

# add date
temp_data = long_temp %>%
    mutate(Date = rep(date, each = (dim(temp_array)[1] * dim(temp_array)[2])))

# save file as RDA
save(temp_data,
     file = "processedData/CEDA_temp_data.rda")

