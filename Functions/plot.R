#plot original map
library(ggplot2)
library(scico)


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

monthname = c("January", "February", "March",
              "April", "May", "June", "July",
              "August", "September", "October",
              "November", "December")

for (i in 1:length(monthname)){
    saveMapMonth(monthname[i])
}

