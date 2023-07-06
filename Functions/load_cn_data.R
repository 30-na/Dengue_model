# load the ncdf4 package
library(ncdf4)
library(RColorBrewer)
library(lattice)
library(dplyr)
library(ggplot2)
library(reshape2)

# open a netCDF file
nc_precip <- nc_open("Data/cru_ts4.06.1901.2021.pre.dat.nc")
print(nc_precip)


# set the variable names
names(nc_precip$var)
names(nc_precip$dim)
x = "lon"
y = "lat"
t = "time"


# get longitude
lon <- sort(ncvar_get(nc_precip,x))

# get latitude
lat <- sort(ncvar_get(nc_precip,y))

# get time
time <- ncvar_get(nc_precip,t)

# Convert numeric time values to date format
date <- as.Date("1900-01-01") + (time - 1)

# Print the converted date values Jan. 1901- Dec. 2021)
range(date)

# get precipitation
pre_array <- ncvar_get(nc_precip, "pre")

# get variables
fullname <- ncatt_get(nc_precip,"pre","long_name")
dunits <- ncatt_get(nc_precip,"pre","units")
fillvalue <- ncatt_get(nc_precip,"pre","_FillValue")
dim(pre_array)


# get global attributes
title <- ncatt_get(nc_precip,0,"title")
institution <- ncatt_get(nc_precip,0,"institution")
datasource <- ncatt_get(nc_precip,0,"source")
references <- ncatt_get(nc_precip,0,"references")
history <- ncatt_get(nc_precip,0,"history")
Conventions <- ncatt_get(nc_precip,0,"Conventions")

 
# close the file
 nc_close(nc_precip)


# replace netCDF fill values with NA's
 pre_array[pre_array==fillvalue$value] <- NA


# # get a single slice or layer (January)
# 
# m=1000
# tmp_slice <- tmp_array[,,m]

# quick map
# image(lon,lat,tmp_slice, col=brewer.pal(10,"RdBu"))

# get dataframe
# df1 = expand.grid( Longitude = 1:dim(tmp_array)[1],
#                   Latitude = 1:dim(tmp_array)[2]) %>%
#     dplyr::mutate(Precipitation = c(tmp_array[ , ,1]))
# 

# Plotting the dataframe using ggplot
# ggplot(df, aes(x = Longitude, y = Latitude, fill = Precipitation)) +
#   geom_tile() +
#   scale_fill_gradient(low = "white", high = "blue") +
#   labs(x = "Longitude", y = "Latitude", title = "Precipitation") +
#   theme_minimal()+
#     facet_grid(~Date)


# df = data.frame(matrix(tmp_array, nrow=dim(tmp_array)[3], byrow=TRUE))
# 
# a = tmp_array[,,5]
# sum(!is.na(a))
# 
# 
date

# Reshape the array to a long format
df <- melt(pre_array)

# Rename the columns
colnames(df) <- c("Longitude", "Latitude", "Date", "Precipitation")

# add date
tempData = df %>%
    mutate(Date1 = rep(date, each = (dim(pre_array)[1] * dim(pre_array)[2])))



rep(1:3, each=4)






