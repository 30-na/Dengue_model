
# load library
library(dplyr)


# load data
load("processedData/R0_30years_countryName.rda")


#get average Ro
R0.mean = R0 %>%
    dplyr::group_by(
        Year,
        Longitude,
        Latitude
        ) %>%
    dplyr::summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T)
        )

save(R0.mean,
     file = "ProcessedData/R0_mean.rda")


    
    
    