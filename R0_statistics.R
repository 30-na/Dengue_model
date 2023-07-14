
# load library
library(dplyr)
library(ggplot2)
library(geonames)

# load the data
load("processedData/R0_data.rda")
options(geonamesUsername="30na")

    
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
           )

R0_30years = df %>%
    dplyr::filter(
        Year >= 1990 & Year <= 2020
        ) %>%
    dplyr::mutate(
        country = geonames::GNcountryCode(lat = Latitude , lng = Longitude)$countryName
        )

save(R0_30years,
     file = "processedData/R0_30years.rda")

R0YearStat = df %>%
    group_by(Year) %>%
    dplyr::summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T),
        mean_ber_alt = mean(r0_A_briere, na.rm = T),
        mean_quad_alt = mean(r0_A_quadratic, na.rm = T)
    ) 

print(R0YearStat)
save(R0YearStat,
     file = "R0YearStat.rda")



R0MonthStat = df %>%
    group_by(Month) %>%
    summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T),
        mean_ber_alt = mean(r0_A_briere, na.rm = T),
        mean_quad_alt = mean(r0_A_quadratic, na.rm = T)
    )
    
print(R0MonthStat)

save(R0MonthStat,
     file = "R0MonthStat.rda")
