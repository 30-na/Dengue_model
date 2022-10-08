#plot original map
library(ggplot2)


load("processedData/R0_January.rda")
r0_map = ggplot() +
    geom_raster(data = R0 , aes(x = x,
                                y = y,
                                fill = r0_inverse)) +
    scale_fill_viridis_c() +
    coord_quickmap()+
    labs(title ="January Global Relative R0 Model for Dengue with inverse precipitation model",
         x = "",
         y = "")+
    guides(fill = guide_colorbar(title = "R0 Number"))
                 #guide_legend(title = "Basic Reproductive Number (R0)"))

ggsave("Figures/r0_January_inverse.jpg",
       r0_map,
       height=4,width=8,scale=1.65)
