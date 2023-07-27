
# load library
library(dplyr)
library(ggplot2)
library(sf)

# load the data
load("processedData/R0_data.rda")
load("processedData/grid_country_clean.rda")




# summary statistics
df = R0_data %>% 
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
    )


R0_YearMean_Map = df %>%
    group_by(Year,
             Longitude,
             Latitude
             ) %>%
    dplyr::summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T),
        mean_ber_alt = mean(r0_A_briere, na.rm = T),
        mean_quad_alt = mean(r0_A_quadratic, na.rm = T)
    )  %>%
    dplyr::left_join(grid_country_clean,
                     by=c("Longitude", "Latitude"))


save(R0_YearMean_Map,
     file = "R0_YearMean_Map_1950to2020.rda")


