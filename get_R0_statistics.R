
library(dplyr)
load("R0_1950to2020.rda")

R0MeanYearStat = R0 %>%
    group_by(Year) %>%
    dplyr::summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T)
    ) 

save(R0MeanYearStat,
     file = "R0MeanYearStat.rda")




R0MeanMonthStat = R0 %>%
    group_by(Month) %>%
    summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T)
    )

save(R0MeanMonthStat,
     file = "R0MeanMonthStat.rda")





R0MaxStatMap = R0 %>%
    group_by(Longitude ,
             Latitude,
             country) %>%
    summarize(
        max_temp = max(Temperature, na.rm = T),
        max_prec = max(Precipitation, na.rm = T),
        max_ber = max(r0_briere, na.rm = T),
        max_quad = max(r0_quadratic, na.rm = T)
    )

save(R0MaxStatMap,
     file = "R0MaxStatMap.rda")





R0MeanStatMap = R0 %>%
    group_by(Longitude ,
             Latitude,
             country) %>%
    summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T)
    )

save(R0MeanStatMap,
     file = "R0MeanStatMap.rda")





R0MeanYearStatMap = R0 %>%
    group_by(Longitude ,
             Latitude,
             country,
             Year) %>%
    summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T)
    )

save(R0MeanYearStatMap,
     file = "R0MeanYearStatMap.rda")





R0MeanMonthStatMap = R0 %>%
    group_by(Longitude ,
             Latitude,
             country,
             Month) %>%
    summarize(
        mean_temp = mean(Temperature, na.rm = T),
        mean_prec = mean(Precipitation, na.rm = T),
        mean_ber = mean(r0_briere, na.rm = T),
        mean_quad = mean(r0_quadratic, na.rm = T)
    )

save(R0MeanMonthStatMap,
     file = "R0MeanMonthStatMap.rda")





