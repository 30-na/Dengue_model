
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
    mutate(
        Year = format(Date, "%Y"),
        Month = format(Date, "%B"),
        Month = factor(Month,
                       levels = c("January", "February", "March", "April", "May", "June",
                                  "July", "August", "September", "October", "November", "December"))
           )


R0YearStat = df %>%
    group_by(Year) %>%
    summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T),
        mean_ber_alt = mean(r0_A_briere, na.rm = T),
        mean_quad_alt = mean(r0_A_quadratic, na.rm = T)
    )

print(R0YearStat)
save(R0YearStat,
     file = "ProcessedData/R0YearStat.rda")



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
     file = "ProcessedData/R0MonthStat.rda")
