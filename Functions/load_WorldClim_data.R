# load libraris
library(dplyr)
library(raster)
library(ggplot2)
library(readxl)



monthList = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
monthname = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
aegypti = raster("Data/aegypti.tif")


for(i in 1:length(monthList)){
    # avg precipiation
    r_p = raster(paste("Data/precipitation/wc2.1_2.5m_prec_", monthList[i], ".tif",
                       sep = ""))
    
    # tempereture
    r_t = raster(paste("Data/avg_temperature/wc2.1_2.5m_tavg_", monthList[i], ".tif",
                       sep = ""))
    
    # resample 
    r_p = resample(r_p,
                   aegypti,
                   method='ngb')
    r_t = resample(r_t,
                   aegypti,
                   method='ngb')
    
    #convert to data frame
    df_p = as.data.frame(r_p, xy = TRUE)
    df_t = as.data.frame(r_t, xy = TRUE)
    
    # merge and rename data 
    climate = df_p %>%
        inner_join(df_t, by=c("x", "y")) %>%
        rename("r" = paste("wc2.1_2.5m_prec_", monthList[i], sep = ""),
               "t" = paste("wc2.1_2.5m_tavg_", monthList[i], sep = ""))
    
    # save dataset
    save(climate,
         file = paste("processedData/World/", monthname[i], ".rda",
                      sep = ""))
}