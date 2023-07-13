
# load library
library(dplyr)
library(ggplot2)


# load the data
load("processedData/R0_data.rda")

    
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


R0YearStat = df %>%
    group_by(Year) %>%
    dplyr::summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T),
        mean_ber_alt = mean(r0_A_briere, na.rm = T),
        mean_quad_alt = mean(r0_A_quadratic, na.rm = T)
    ) %>%
    dplyr::mutate(
        temp_diff = mean_temp - mean(mean_temp, na.rm = T),
        prec_diff = mean_prec - mean(mean_prec, na.rm = T),
        ber_diff = mean_ber - mean(mean_ber, na.rm = T),
        quad_diff = mean_quad - mean(mean_quad , na.rm = T),
        ber_alt_diff = mean_ber_alt - mean(mean_ber_alt , na.rm = T),
        quad_alt_diff = mean_quad_alt - mean(mean_quad_alt, na.rm = T)
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
