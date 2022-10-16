#plot original map
library(ggplot2)
library(scico)
library(raster)


#plot precipitation
savePrecipitationMap = function(){
    
    listFile = list.files(path = "Data/precipitation", pattern = "*.tif")
    monthname = c("January", "February", "March",
                  "April", "May", "June", "July",
                  "August", "September", "October",
                  "November", "December")
    
    for (i in 1:length(listFile)){
        r = raster(paste("Data/precipitation/", listFile[i], sep=""))
        df = as.data.frame(r, xy=TRUE)
        colnames(df) = c("x", "y", "precipitation")
        g = ggplot() +
            geom_raster(data = df,
                        aes (x = x,
                             y = y,
                             fill = precipitation))+
            scico::scale_fill_scico(palette = "oslo",
                                    direction = -1)+
            labs(title = paste(monthname[i], " precipitation (mm) from WorldClim 1970-2000",  sep=""),
                 xlab="",
                 ylab="")+
            theme_minimal()+
            theme(axis.title.x=element_blank(),
                  axis.title.y=element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  axis.text.y = element_blank(),
                  plot.background = element_blank(),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())
        ggsave(paste("Figures/precipitation/", monthname[i], ".jpg", sep=""),
               height=4,
               width=8,
               scale=1.6)
        
    }
}

savePrecipitationMap()


## map function for temperature
saveTemperatureMap = function(){
    
    listFile = list.files(path = "Data/avg_temperature", pattern = "*.tif")
    monthname = c("January", "February", "March",
                  "April", "May", "June", "July",
                  "August", "September", "October",
                  "November", "December")
    
    for (i in 1:length(listFile)){
        r = raster(paste("Data/avg_temperature/", listFile[i], sep=""))
        df = as.data.frame(r, xy=TRUE)
        colnames(df) = c("x", "y", "Temperature")
        g = ggplot() +
            geom_raster(data = df,
                        aes (x = x,
                             y = y,
                             fill = Temperature))+
            scico::scale_fill_scico(palette = "roma",
                                    direction = -1)+
            labs(title = paste(monthname[i], " average temperature (°C) from WorldClim 1970-2000",  sep=""),
                 xlab="",
                 ylab="")+
            theme_minimal()+
            theme(axis.title.x=element_blank(),
                  axis.title.y=element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  axis.text.y = element_blank(),
                  plot.background = element_blank(),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank())
        
        ggsave(paste("Figures/avg_temperature/", monthname[i], ".jpg", sep=""),
               height=4,
               width=8,
               scale=1.6)
        
    }
}

saveTemperatureMap()





## map function for Global Aedes Distribution
r = raster("Data/aegypti.tif")
df = as.data.frame(r, xy=TRUE)
colnames(df) = c("x", "y", "aegypti")
g = ggplot() +
    geom_raster(data = df,
                aes (x = x,
                     y = y,
                     fill = aegypti))+
    scico::scale_fill_scico(palette = "lajolla",
                            direction = 1)+
    labs(title = "Probability of aegypti occurrence",
         xlab="",
         ylab="")+
    theme_minimal()+
    theme(axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.y = element_blank(),
          plot.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())

ggsave("Figures/aegypti.jpg",
       height=4,
       width=8,
       scale=1.6)




## map function for Global Aedes Distribution
load("processedData/globalEconomic.rda")
df = globalEconomic
colnames(df) = c("x", "y", "Risk")
g = ggplot() +
    geom_raster(data = df,
                aes (x = x,
                     y = y,
                     fill = Risk))+
    scico::scale_fill_scico(palette = "lajolla",
                            direction = 1)+
    labs(title = "Risk of exposure",
         xlab="",
         ylab="")+
    theme_minimal()+
    theme(axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.y = element_blank(),
          plot.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())

ggsave("Figures/risk_exposure.jpg",
       height=4,
       width=8,
       scale=1.6)
