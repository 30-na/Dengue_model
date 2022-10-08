#plot original map
library(ggplot2)


load("processedData/R0_january.rda")
r0_map = ggplot() +
    geom_raster(data = R0 , aes(x = x,
                                y = y,
                                fill = r0)) +
    scale_fill_viridis_c() +
    coord_quickmap()+
    labs(title ="Global Relative R0 Model for Dengue (January)",
         x = "",
         y = "")

ggsave("Figures/r0_January.jpg",
       r0_map,
       height=4,width=8,scale=1.65)
