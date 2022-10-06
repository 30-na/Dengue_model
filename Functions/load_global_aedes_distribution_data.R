######## Global Aedes Distribution ##########
# Uncertainty estimates for mosquito distribution at 5 km x 5 km resolution
library(raster)
library(ggplot2)
path = "Data"
url = "https://www.dropbox.com/sh/bpxcmzmmpiiav8u/AAAl3CBKnBYwXb0n1s1C4-K-a?dl=0&preview=aegypti.tif"
filename = "aegypti.tif"
destfile = paste(getwd(),
                 path,
                 filename,
                 sep = "/")

# download zip file
if(!file.exists(destfile)){
    download.file(url = url,
                  destfile = destfile)
}


r = raster(paste(path, filename, sep = "/"))
aegypti = as.data.frame(r, xy = TRUE) %>%
    rename("P_ae" = aegypti) 


# save list of files for each month
save(aegypti,
     file = "processedData/aegypti.rda")




# plot the file
P_ae_map = ggplot() +
    geom_raster(data = P_ae , aes(x = x,
                                     y = y,
                                     fill = aegypti)) +
    scale_fill_viridis_c() +
    coord_quickmap()+
    labs(title ="Global Aedes Distribution",
         x = "",
         y = "")

ggsave("Figures/global_Aedes_distribution.jpg",
       P_ae_map,
       height=4,width=8,scale=1.65)





