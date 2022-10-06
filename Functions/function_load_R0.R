# load library
library(dplyr)
library(raster)
library(ggplot2)



month = "January"
load(paste("processedData/World/", month , ".RDA" , sep = ""))
load("processedData/aegypti.rda")
load("processedData/globalEconomic.rda")


# merge datasets
R0 = aegypti %>%
    left_join(climate, by = c("x", "y")) %>%
    left_join(globalEconomic, by = c("x", "y"))%>%
    mutate(b = 2.02*10^(-4)*t*(t-13.35)*sqrt(40.08-t),
           B_vh = 8.49*10^(-4)*t*(t-17.05)*sqrt(35.83-t),
           B_hv = -3.54*10^(-3)*(t-38.38)*(t-22.72),
           sigma_v = 1.74*10^(-4)*t*(t-18.27)*sqrt(42.31-t),
           theta = 8.56*10^(-3)*t*(t-14.58)*sqrt(34.61-t),
           nu = -5.99*10^(-3)*(t-38.29)*(t-13.56),
           pi = 7.86*10^(-5)*t*(t-11.36)*sqrt(39.17-t),
           mu = 1/(-3.02*10^(-1)*(t-11.25)*(t-37.22)),
           gamma = 1/5,
           K = 1000,
           N_h = 1,
           c_briere = 7.86*10^(-5),
           z_briere = .28,
           c_quad = -5.99*10^(-3),
           z_quad = 0.025,
           FR_briere = ifelse(r > 246,
                              0,
                              c_briere*r*(r-0)*sqrt(246-r)*z_briere),
           r0 = ifelse((theta*nu*pi) < mu^2,
                       0,
                       sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_briere * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * sigma_v+mu * N_h))))
           
           
save(R0,
     file = "processedData/R0_january.rda")
#plot original map

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
           
           