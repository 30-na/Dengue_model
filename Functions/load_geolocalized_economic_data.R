# load library
library(dplyr)
library(raster)
library(ggplot2)
library(readxl)

######## Geolocalized Economic Data ##########

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
gEcon = read_excel("Data/Gecon40_post_final.xls",sheet = 1)

# select coulmn and calculate risk of exposure
PPP = gEcon %>%
    select(LAT, LONGITUDE, PPP2005_40) %>%
    mutate(PPP_tranformed = log(PPP2005_40*exp(0.47))) %>%
    mutate(risk_exposure = case_when(PPP_tranformed < 1.97 ~ 1,
                                     PPP_tranformed > 4.911 ~ 0,
                                     PPP_tranformed > 1.97 & PPP_tranformed < 4.911 ~ (1.67-(0.34*PPP_tranformed))))

RPP = rasterFromXYZ(PPP[,c(2,1,5)])
RPP
# load("processedData/precipitation_list_file.rda")
# r = rasterFromXYZ(precipitation_list_file[[1]])
res(r)
res(RPP)
r
RPP
r - raster("Data/precipitation/wc2.1_2.5m_prec_01.tif")
r
risk_expsure_map = ggplot() +
    geom_tile(data = PPP , aes(x = LONGITUDE, y = LAT,
                                         fill = risk_exposure))+
    scale_fill_viridis_c(direction = 1) +
    ggtitle("Risk of Exposure")

ggsave("Figures/risk_expsure_map.jpg",
       risk_expsure_map,
       height=4,width=8,scale=1.65)


# save list of files for each month
save(PPP,
     file = "processedData/PPP.rda")


gr = plot(r)
file_df <- as.data.frame(r)
names(file_df)
gr = ggplot() +
    geom_raster(data = file_df , aes(x = nrow(r), y = nrow(r), fill = wc2.1_2.5m_prec_01)) + #spei_03 is the name of the column whose values I want to plot. 
    scale_fill_viridis_c() +
    coord_quickmap()

save(file = "p.jpg", gr)
