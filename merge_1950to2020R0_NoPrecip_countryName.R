
# load library
library(dplyr)
library(ggplot2)


# load the data
load("processedData/R0_data_NoPrecip.rda")
load("processedData/grid_country_clean.rda")




# summary statistics
R0 = R0_data %>% 
    dplyr::rename(
        "Temperature" = t,
        "Precipitation" = r
    )%>%
    dplyr::mutate(
        Year = format(Date, "%Y"),
        Month = format(Date, "%B"),
        Month = factor(Month,
                       levels = c("January", "February", "March", "April", "May", "June",
                                  "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::filter(
        Year >= 1950 & Year <= 2020
    )  %>%
    dplyr::left_join(grid_country_clean,
                     by=c("Longitude", "Latitude"))
save(R0,
     file = "R0_1950to2020.rda")