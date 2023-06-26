#plot original map
library(ggplot2)
library(sf)
library(rnaturalearth)

saveMapMonth = function(month){
    load(paste("processedData/R0_A_", month, ".rda", sep=""))
    spdf_world = rnaturalearth::ne_countries(returnclass="sf")
    
    
    # Inverse precipitation model
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_A_inverse)) +
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
    
    
    ggsave(paste("Figures/inverse/r0_A_", month, "inverse.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1)
    
    
    
    
    
    # Briere precipitation model
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_A_briere)) +
        scico::scale_fill_scico(palette = "lajolla")+
        
        labs(title =paste(month, " Global Relative R0 Model for Dengue",
                          sep = ""),
             x = "",
             y = "",
             subtitle = "Briere precipitation model")+
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
    
    
    ggsave(paste("Figures/briere/r0_A_", month, "briere.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1)
    
    
    
    
    
    
    
    # Quadratic precipitation model
    r0_map = ggplot() +
        geom_raster(data = R0 , aes(x = x,
                                    y = y,
                                    fill = r0_A_quadratic)) +
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
    
    
    ggsave(paste("Figures/quadratic/r0_A_", month, "quadratic.jpg", sep="_"),
           r0_map,
           height=4,width=8,scale=1.0)
    
}


saveMapMonth("January")
