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
