#plot original map
library(ggplot2)
library(sf)
library(rnaturalearth)

saveMap = function(Pfunction, month){
    load(paste("processedData/R0_", month, ".rda", sep=""))
    
    
    if(Pfunction == "briere"){
        raster = geom_raster(data = R0 , aes(x = x,
                                             y = y,
                                             fill = r0_briere))
    }
    
    if(Pfunction == "quadratic"){
        raster = geom_raster(data = R0 , aes(x = x,
                                             y = y,
                                             fill = r0_quadratic))
    }
    
    if(Pfunction == "inverse"){
        raster = geom_raster(data = R0 , aes(x = x,
                                             y = y,
                                             fill = r0_inverse))
    }
    
    r0_map = ggplot() +
        raster +
        #scale_fill_gradient(low = "grey", high = "brown") +
        scico::scale_fill_scico(palette = "lajolla")+
        coord_quickmap()+
        labs(title =paste(month, " Global Relative R0 Model for Dengue with ", Pfunction, " precipitation model",
        sep = ""),
             x = "",
             y = "")+
        guides(fill = guide_colorbar(title = "R0 Number"))
    #guide_legend(title = "Basic Reproductive Number (R0)"))
    
    ggsave(paste("Figures/r0", month, Pfunction, ".jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1.65)
}



saveMapMonth = function(month){
    load(paste("processedData/R0_", month, ".rda", sep=""))
    
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_quadratic)) +
        #scale_fill_gradient(low = "grey", high = "brown") +
        scico::scale_fill_scico(palette = "lajolla")+
        coord_quickmap()+
        labs(title =paste(month, " Global Relative R0 Model for Dengue with quadratic precipitation model",
                          sep = ""),
             x = "",
             y = "")+
        guides(fill = guide_colorbar(title = "R0 Number"))
    #guide_legend(title = "Basic Reproductive Number (R0)"))
    
    ggsave(paste("Figures/r0", month, "quadratic.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1.65)
    
    
    
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_inverse)) +
        #scale_fill_gradient(low = "grey", high = "brown") +
        scico::scale_fill_scico(palette = "lajolla")+
        coord_quickmap()+
        labs(title =paste(month, " Global Relative R0 Model for Dengue with inverse precipitation model",
                          sep = ""),
             x = "",
             y = "")+
        guides(fill = guide_colorbar(title = "R0 Number"))
    #guide_legend(title = "Basic Reproductive Number (R0)"))
    
    ggsave(paste("Figures/r0", month, "inverse.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1.65)
}




saveMapMonth = function(month){
    load(paste("processedData/R0_", month, ".rda", sep=""))
    spdf_world = rnaturalearth::ne_countries(returnclass="sf")
    
    
    
    
    
    # Without Precipitation model
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_NoFR)) +
        scico::scale_fill_scico(palette = "lajolla")+
        
        labs(title =paste(month, " Global Relative R0 Model for Dengue",
                          sep = ""),
             x = "",
             y = "",
             subtitle = "Without precipitation model")+
        theme_minimal()+
        theme(axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              axis.ticks.x = element_blank(),
              axis.text.x = element_blank(),
              axis.ticks.y = element_blank(),
              axis.text.y = element_blank(),
              plot.background = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())+
        guides(fill = guide_colorbar(title = "R0 Number"))+
        geom_sf(data = spdf_world, fill = "transparent")+
        coord_sf(xlim = c(min(R0$x), max(R0$x)), ylim = c(min(R0$y), max(R0$y)), expand = FALSE)

    
    ggsave(paste("Figures/without_FR/r0", month, "without_FR.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1.65)
    
    
    
    
    
    # Inverse precipitation model
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_inverse)) +
        scico::scale_fill_scico(palette = "lajolla")+
        
        labs(title =paste(month, " Global Relative R0 Model for Dengue",
                          sep = ""),
             x = "",
             y = "",
             subtitle = "Inverse precipitation model")+
        theme_minimal()+
        theme(axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              axis.ticks.x = element_blank(),
              axis.text.x = element_blank(),
              axis.ticks.y = element_blank(),
              axis.text.y = element_blank(),
              plot.background = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())+
        guides(fill = guide_colorbar(title = "R0 Number"))+
        geom_sf(data = spdf_world, fill = "transparent")+
        coord_sf(xlim = c(min(R0$x), max(R0$x)), ylim = c(min(R0$y), max(R0$y)), expand = FALSE)

    
    ggsave(paste("Figures/inverse/r0", month, "inverse.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1.65)
    
    
    
    
    
    
    # Quadratic precipitation model
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_quadratic)) +
        scico::scale_fill_scico(palette = "lajolla")+
        
        labs(title =paste(month, " Global Relative R0 Model for Dengue",
                          sep = ""),
             x = "",
             y = "",
             subtitle = "Quadratic precipitation model")+
        theme_minimal()+
        theme(axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              axis.ticks.x = element_blank(),
              axis.text.x = element_blank(),
              axis.ticks.y = element_blank(),
              axis.text.y = element_blank(),
              plot.background = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())+
        guides(fill = guide_colorbar(title = "R0 Number"))+
        geom_sf(data = spdf_world, fill = "transparent")+
        coord_sf(xlim = c(min(R0$x), max(R0$x)), ylim = c(min(R0$y), max(R0$y)), expand = FALSE)

    
    ggsave(paste("Figures/quadratic/r0", month, "quadratic.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1.65)
    
}


monthname = c("January", "February", "March",
              "April", "May", "June", "July",
              "August", "September", "October",
              "November", "December")

for (i in 1:length(monthname)){
    saveMapMonth(monthname[i])
}

