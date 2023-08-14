library(dplyr)
load("processedData/R0_data_NoPrecip.rda")

names(R0_data)

R0 = R0_data %>% 
    dplyr::rename(
        "Temperature" = t,
    )%>%
    dplyr::select(
        Longitude,
        Latitude,
        Temperature,
        Date,
        r0_briere,
        r0_quadratic
    )

save(R0,
     file = "R0_1950to2020_NoPrecip.rda")