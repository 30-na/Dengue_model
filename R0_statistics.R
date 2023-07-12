
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


# calculate the average of the average
average_temp = mean(R0MonthStat$mean_temp, na.rm = T)
average_prec = mean(R0MonthStat$mean_prec, na.rm = T)
average_berier = mean(R0MonthStat$mean_ber, na.rm = T)
average_quad = mean(R0MonthStat$mean_quad , na.rm = T)
average_berier_alter = mean(R0MonthStat$mean_ber_alt , na.rm = T)
average_quad_alter = mean(R0MonthStat$mean_quad_alt, na.rm = T) 

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
        temp_diff = mean_temp - average_temp,
        prec_diff = mean_prec - average_prec,
        ber_diff = mean_ber - average_berier,
        quad_diff = mean_quad - average_quad,
        ber_alt_diff = mean_ber_alt - average_berier_alter,
        quad_alt_diff = mean_quad_alt - average_quad_alter
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
