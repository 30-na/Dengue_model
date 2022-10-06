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
lowest_ppp = gEcon %>%
    select(PPP2005_40, COUNTRY) %>%
    group_by(COUNTRY)%>%
    summarize(lowest = min(PPP2005_40)) %>%
    filter(COUNTRY == "Djibouti")

PPP = gEcon %>%
    select(LAT, LONGITUDE, PPP2005_40, COUNTRY)%>%
    # replace Somalia PPP2005_40 value with lowest Djibouti PPP2005_40
    mutate(PPP2005_40 = if_else(COUNTRY == "Somalia" , lowest_ppp$lowest, PPP2005_40))%>%
    
    mutate(PPP_tranformed = log(PPP2005_40*exp(0.47))) %>%
    mutate(risk_exposure = case_when(PPP_tranformed < 1.97 ~ 1,
                                     PPP_tranformed > 4.911 ~ 0,
                                     PPP_tranformed > 1.97 & PPP_tranformed < 4.911 ~ (1.67-(0.34*PPP_tranformed)))) %>%
    select("x" = LONGITUDE,
           "y" = LAT,
           "R_se" = risk_exposure)

# change it to raster format
RPP = rasterFromXYZ(PPP)


# resample 
aegypti = raster("Data/aegypti.tif")
RPP = resample(RPP,
               aegypti,
               method = "ngb")

#convert to dataframe
globalEconomic = as.data.frame(RPP, xy = TRUE)

# save files 
save(globalEconomic,
     file = "processedData/globalEconomic.rda")


#plot original map
risk_expsure_map = ggplot() +
    geom_tile(data = PPP , aes(x = x, y = y,
                                         fill = R_se))+
    scale_fill_viridis_c(direction = 1) +
    ggtitle("Risk of Exposure")

ggsave("Figures/risk_expsure_map.jpg",
       risk_expsure_map,
       height=4,width=8,scale=1.65)




# plot resample map
t_map = ggplot() +
    geom_raster(data = globalEconomic , aes(x = x,
                                     y = y,
                                     fill = R_se)) +
    scale_fill_viridis_c() +
    coord_quickmap() +
    labs(title  = "Risk of Exposure resample",
         x = "",
         y = "")

ggsave("Figures/risk_expsure_map_resample.jpg",
       t_map,
       height=4,width=8,scale=1.65)

