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
# path = "Data/min_temperature"
# url = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmin.zip"
# filename = "wc2.1_2.5m_tmin.zip"
# destfile = paste(getwd(),
#                  path,
#                  filename,
#                  sep = "/")
# 
# # download zip file
# if(!file.exists(destfile)){
#     download.file(url = url,
#                   destfile = destfile)
# }
# 
# # unzip file
# unzip(destfile,
#       exdir = path)
# 
# # save all tif files as dataframe in a list
# list_files_name_min = list.files(path = path,
#                              pattern = "*.tif")
# 
# min_temperature_list_file = list()
# for(i in 1:length(list_files_name_min)){
#     filename = list_files_name_min[i]
#     r = raster(paste(path,
#                      filename,
#                      sep = "/"))
#     df = as.data.frame(r, xy = TRUE)
#     min_temperature_list_file[[i]] = df
# }
# 
# # save list of files for each month
# save(min_temperature_list_file,
#      file = "processedData/min_temperature_list_file.rda")



######## Max Tempreature (2.5 minutes) ##########
# path = "Data/max_temperature"
# url = "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmax.zip"
# filename = "wc2.1_2.5m_tmax.zip"
# destfile = paste(getwd(),
#                  path,
#                  filename,
#                  sep = "/")
# 
# # download zip file
# if(!file.exists(destfile)){
#     download.file(url = url,
#                   destfile = destfile)
# }
# 
# # unzip file
# unzip(destfile,
#       exdir = path)
# 
# # save all tif files as dataframe in a list
# list_files_name_max = list.files(path = path,
#                                  pattern = "*.tif")
# 
# max_temperature_list_file = list()
# for(i in 1:length(list_files_name_max)){
#     filename = list_files_name_max[i]
#     r = raster(paste(path,
#                      filename,
#                      sep = "/"))
#     df = as.data.frame(r, xy = TRUE)
#     max_temperature_list_file[[i]] = df
# }
# 
# # save list of files for each month
# save(max_temperature_list_file,
#      file = "processedData/max_temperature_list_file.rda")


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


##################### sample data for January ################
# avg tempereture
r_p = raster("Data/precipitation/wc2.1_2.5m_prec_01.tif")

# resample 
aegypti = raster("Data/aegypti.tif")
r_p = resample(r_p,
               aegypti,
               method='ngb')

#convert to data frame
df_p = as.data.frame(r_p, xy = TRUE)




# precipiation
r_t = raster("Data/avg_temperature/wc2.1_2.5m_tavg_01.tif")

# resample 
r_t = resample(r_t,
               aegypti,
               method='ngb')

#convert to data frame
df_t = as.data.frame(r_t, xy = TRUE)




# merge and rename data 
climate = df_p %>%
    inner_join(df_t, by=c("x", "y")) %>%
    rename("r" = wc2.1_2.5m_prec_01,
           "t" = wc2.1_2.5m_tavg_01)



# save dataset
save(climate,
     file = "processedData/World/January.rda")



# plot 
t_map = ggplot() +
    geom_raster(data = climate , aes(x = x,
                                  y = y,
                                  fill = t)) +
    scale_fill_viridis_c() +
    coord_quickmap() +
    labs(title  = "Average Tempereture in January",
         x = "",
         y = "")
    

ggsave("Figures/avgTempereture_January.jpg",
       t_map,
       height=4,width=8,scale=1.65)


r_map = ggplot() +
    geom_raster(data = climate , aes(x = x,
                                     y = y,
                                     fill = r)) +
    scale_fill_viridis_c() +
    coord_quickmap()+
    labs(title ="Precipitation in January",
         x = "",
         y = "")

ggsave("Figures/precipitation_January.jpg",
       r_map,
       height=4,width=8,scale=1.65)


