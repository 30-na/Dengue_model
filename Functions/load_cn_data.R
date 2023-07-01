# load the ncdf4 package
library(ncdf4)
library(RColorBrewer)
library(lattice)


# set path and filename
ncpath <- "Data/"
ncname <- "Complete_TAVG_LatLong1.nc"  
ncfname <- paste(ncpath, ncname, sep="")


# set the variable names
names(ncin$var)
dname <- "temperature"  # note: tmp means temperature (not temporary)
names(ncin$dim)
# x = "longitude"
# y = "latitude"

x = "longitude"
y = "latitude"


t = "time"




# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)


# get longitude
lon <- sort(ncvar_get(ncin,x))
nlon <- dim(lon)
head(lon)

# get latitude
lat <- sort(ncvar_get(ncin,y))
nlat <- dim(lat)
head(lat)
print(c(nlon,nlat))

# get time
time <- ncvar_get(ncin,t)
time


tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt

# get temperature
tmp_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(tmp_array)


# # get global attributes
title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"source")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")
# 
# # close the file
# nc_close(ncin)
# 

# # Convert time to year and month and date format
# year <- floor(time)
# month <- round(((time - year) * 12) + .5, 0)
# date = as.Date(paste(year, month, "15", sep="-"))


# replace netCDF fill values with NA's
# tmp_array[tmp_array==fillvalue$value] <- NA
# length(na.omit(as.vector(tmp_array[,,1])))

# get a single slice or layer (January)
m <- 2900
tmp_slice <- tmp_array[,,m]

# quick map
#png("my_plot.png")
#image(lon,lat,tmp_slice, col=rev(brewer.pal(10,"RdBu")), ylim = rev(range(lat)))
image(lon,lat,tmp_slice, col=brewer.pal(10,"RdBu"))
#dev.off()

