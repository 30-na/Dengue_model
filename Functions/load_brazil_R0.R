library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)
library(raster)
library(readxl)
library(writexl)

# load brazil climate data
brazil_file = fread("Data/conventional_weather_stations_inmet_brazil_1961_2019.csv")



# Average Compensated Temperature and precipitation daily
brazil_daily = brazil_file %>%
    dplyr::select("date" = Data,
                  "preciptation" = Precipitacao,
                  "temperature" = "Temp Comp Media") %>%
    mutate(date = as.Date(date, format = "%d/%m/%Y")) %>%
    group_by(date) %>%
    summarize(temp = mean(temperature, na.rm = TRUE),
              precip = mean(preciptation, na.rm = TRUE))


fig_temp_date = ggplot(brazil_daily, aes(x = date, y = temp)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil daily temperature change (1961-2019)",
         x = "Date",
         y = "Temperature")


ggsave("Figures/temp_date.jpg",
       fig_temp_date,
       height=4,width=8,scale=1)




fig_precip_date = ggplot(brazil_daily, aes(x = date, y = precip)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil daily precipitation change (1961-2019)",
         x = "Date",
         y = "Precipitation")


ggsave("Figures/precip_date.jpg",
       fig_precip_date,
       height=4,width=8,scale=1)





# Average Compensated Temperature and precipitation Weekly
brazil_weekly = brazil_file %>%
    dplyr::select("date" = Data,
                  "preciptation" = Precipitacao,
                  "temperature" = "Temp Comp Media") %>%
    mutate(date = as.Date(date, format = "%d/%m/%Y"),
           week = floor_date(date, "week")) %>%
    group_by(week) %>%
    summarize(temp = mean(temperature, na.rm = TRUE),
              precip = mean(preciptation, na.rm = TRUE))


fig_precip_week = ggplot(brazil_weekly, aes(x = week, y = precip)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil weekly preciptation change (1961-2019)",
         x = "Date",
         y = "Preciptation")
    

ggsave("Figures/precip_week.jpg",
       fig_precip_week,
       height=4,width=8,scale=1)





fig_temp_week = ggplot(brazil_weekly, aes(x = week, y = temp)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil weekly temperature change (1961-2019)",
         x = "Date",
         y = "Temperature")


ggsave("Figures/temp_week.jpg",
       fig_temp_week,
       height=4,width=8,scale=1)






# Average Compensated Temperature and precipitation monthly
brazil_monthly = brazil_file %>%
    dplyr::select("date" = Data,
                  "preciptation" = Precipitacao,
                  "temperature" = "Temp Comp Media") %>%
    mutate(date = as.Date(date, format = "%d/%m/%Y"),
           month = floor_date(date, "month")) %>%
    group_by(month) %>%
    summarize(temp = mean(temperature, na.rm = TRUE),
              precip = mean(preciptation, na.rm = TRUE))


fig_temp_month = ggplot(brazil_monthly, aes(x = month, y = temp)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil monthly temperature change (1961-2019)",
         x = "Date",
         y = "Temperature")


ggsave("Figures/temp_month.jpg",
       fig_temp_month,
       height=4,width=8,scale=1)



fig_precip_month = ggplot(brazil_monthly, aes(x = month, y = precip)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil monthly preciptation change (1961-2019)",
         x = "Date",
         y = "Preciptation")


ggsave("Figures/precip_month.jpg",
       fig_precip_month,
       height=4,width=8,scale=1)



######## average Geolocalized Economic Data for brazil
# read the file
gEcon = read_excel("Data/Gecon40_post_final.xls",sheet = 1)

PPP = gEcon %>%
    dplyr::select(LAT, LONGITUDE, PPP2005_40, COUNTRY)%>%
    mutate(PPP_tranformed = log(PPP2005_40*exp(0.47))) %>%
    mutate(risk_exposure = case_when(PPP_tranformed < 1.97 ~ 1,
                                     PPP_tranformed > 4.911 ~ 0,
                                     PPP_tranformed > 1.97 & PPP_tranformed < 4.911 ~ (1.67-(0.34*PPP_tranformed)))) %>%
    dplyr::select("x" = LONGITUDE,
                  "y" = LAT,
                  "country" = COUNTRY,
                  "R_se" = risk_exposure)

# change it to raster format
RPP = rasterFromXYZ(PPP)

# resample 
aegypti = raster("Data/aegypti.tif")
aegypti = resample(aegypti,
                   RPP,
               method = "ngb")

#convert to dataframe
aegypti_df = as.data.frame(aegypti, xy = TRUE)

aeg_re = inner_join(PPP,aegypti_df, by = c("x", "y")) %>%
    filter(country == "Brazil") 
R_se_brazil = mean(aeg_re$R_se, na.rm = TRUE)
aegypti_brazil = mean(aeg_re$aegypti, na.rm = TRUE)

#### R0 weekly
R0_weekly = brazil_weekly %>%
    rename("t" = temp,
           "r" = precip)%>%
    mutate(P_ae = aegypti_brazil,
           R_se = R_se_brazil,
           b = ifelse(t <= 13.35 | t >= 40.08,
                      0,
                      2.02*10^(-4)*t*(t-13.35)*sqrt(40.08-t)),

           B_vh = ifelse(t <= 17.05 | t >= 35.83,
                         0,
                         8.49*10^(-4)*t*(t-17.05)*sqrt(35.83-t)),
           # beta_hv = 4.91E-04*T*(T-12.22)*(37.46-T)^0.5(corrected formula)
           B_hv = ifelse(t <= 12.22 | t >= 37.46,
                         0,
                         4.91*10^(-04)*t*(t-12.22)*sqrt(37.46-t)),

           sigma_v = ifelse(t <= 18.27 | t >= 42.31,
                            0,
                            1.74*10^(-4)*t*(t-18.27)*sqrt(42.31-t)),

           theta = ifelse(t <= 14.58 | t >= 34.61,
                          0,
                          8.56*10^(-3)*t*(t-14.58)*sqrt(34.61-t)),

           nu = ifelse(t <= 13.56 | t >= 38.29,
                       0,
                       -5.99*10^(-3)*(t-38.29)*(t-13.56)),

           pi = ifelse(t <= 11.36 | t >= 39.17,
                       0,
                       7.86*10^(-5)*t*(t-11.36)*sqrt(39.17-t)),

           mu = ifelse(t <= 11.25 | t >= 37.22,
                       Inf,
                       1/(-3.02*10^(-1)*(t-11.25)*(t-37.22))),
           gamma = 1/5,
           K = 20,
           N_h = 1,
           c_briere = 7.86*10^(-5),
           z_briere = .05,
           c_quad = -5.99*10^(-3),
           z_quad = 0.025,
           z_inverse = 0.6,
           # 246 corrected value
           FR_briere = ifelse(r > 246 | r < 1,
                              0,
                              c_briere*r*(r-1)*sqrt(246-r)*z_briere),

           FR_quad = ifelse(r < 1 | r > 123,
                            0,
                            c_quad*(r-1)*(r-123)*z_quad),

           FR_inverse = 1/r*z_inverse,

           r0_briere = ifelse(is.na(R_se),
                              NA_real_,
                              ifelse((theta*nu*pi) < mu^2 | is.infinite(FR_briere),
                                     0,
                                     sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_briere * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))),

           r0_quadratic = ifelse(is.na(R_se),
                                 NA_real_,
                                 ifelse((theta*nu*pi) < mu^2 | is.infinite(FR_quad),
                                        0,
                                        sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_quad * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))),

           r0_inverse = ifelse(is.na(R_se),
                               NA_real_,
                               ifelse((theta*nu*pi) < mu^2 | is.infinite(FR_inverse),
                                      0,
                                      sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_inverse * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))),

           r0_NoFR = ifelse(is.na(R_se),
                            NA_real_,
                            ifelse((theta*nu*pi) < mu^2,
                                   0,
                                   sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * 1 * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))))
    
#names(R0)   
fig_r0_quad_weekly = ggplot(R0_weekly, aes(x = week, y = r0_quadratic)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil R0 quadratic weekly change (1961-2019)",
         x = "Date",
         y = "R0")

ggsave("Figures/fig_r0_quad_weekly.jpg",
       fig_r0_quad_weekly,
       height=4,width=8,scale=1)


fig_r0_briere_weekly = ggplot(R0_weekly, aes(x = week, y = r0_briere)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil R0 briere weekly change (1961-2019)",
         x = "Date",
         y = "R0")

ggsave("Figures/fig_r0_briere_weekly.jpg",
       fig_r0_briere_weekly,
       height=4,width=8,scale=1)


fig_r0_inverse_weekly = ggplot(R0_weekly, aes(x = week, y = r0_inverse)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil R0 inverse weekly change (1961-2019)",
         x = "Date",
         y = "R0")

ggsave("Figures/fig_r0_inverse_weekly.jpg",
       fig_r0_inverse_weekly,
       height=4,width=8,scale=1)













#### R0 Monthly
write_xlsx(brazil_monthly,
           "processedData/monthly_brazil.xlsx")

R0_monthly = brazil_monthly %>%
    rename("t" = temp,
           "r" = precip)%>%
    mutate(P_ae = aegypti_brazil,
           R_se = R_se_brazil,
           b = ifelse(t <= 13.35 | t >= 40.08,
                      0,
                      2.02*10^(-4)*t*(t-13.35)*sqrt(40.08-t)),
           
           B_vh = ifelse(t <= 17.05 | t >= 35.83,
                         0,
                         8.49*10^(-4)*t*(t-17.05)*sqrt(35.83-t)),
           # beta_hv = 4.91E-04*T*(T-12.22)*(37.46-T)^0.5(corrected formula)
           B_hv = ifelse(t <= 12.22 | t >= 37.46,
                         0,
                         4.91*10^(-04)*t*(t-12.22)*sqrt(37.46-t)),
           
           sigma_v = ifelse(t <= 18.27 | t >= 42.31,
                            0,
                            1.74*10^(-4)*t*(t-18.27)*sqrt(42.31-t)),
           
           theta = ifelse(t <= 14.58 | t >= 34.61,
                          0,
                          8.56*10^(-3)*t*(t-14.58)*sqrt(34.61-t)),
           
           nu = ifelse(t <= 13.56 | t >= 38.29,
                       0,
                       -5.99*10^(-3)*(t-38.29)*(t-13.56)),
           
           pi = ifelse(t <= 11.36 | t >= 39.17,
                       0,
                       7.86*10^(-5)*t*(t-11.36)*sqrt(39.17-t)),
           
           mu = ifelse(t <= 11.25 | t >= 37.22,
                       Inf,
                       1/(-3.02*10^(-1)*(t-11.25)*(t-37.22))),
           gamma = 1/5,
           K = 20,
           N_h = 1,
           c_briere = 7.86*10^(-5),
           z_briere = .05,
           c_quad = -5.99*10^(-3),
           z_quad = 0.025,
           z_inverse = 0.6,
           # 246 corrected value
           FR_briere = ifelse(r > 246 | r < 1,
                              0,
                              c_briere*r*(r-1)*sqrt(246-r)*z_briere),
           
           FR_quad = ifelse(r < 1 | r > 123,
                            0,
                            c_quad*(r-1)*(r-123)*z_quad),
           
           FR_inverse = 1/r*z_inverse,
           
           r0_briere = ifelse(is.na(R_se),
                              NA_real_,
                              ifelse((theta*nu*pi) < mu^2 | is.infinite(FR_briere),
                                     0,
                                     sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_briere * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))),
           
           r0_quadratic = ifelse(is.na(R_se),
                                 NA_real_,
                                 ifelse((theta*nu*pi) < mu^2 | is.infinite(FR_quad),
                                        0,
                                        sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_quad * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))),
           
           r0_inverse = ifelse(is.na(R_se),
                               NA_real_,
                               ifelse((theta*nu*pi) < mu^2 | is.infinite(FR_inverse),
                                      0,
                                      sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_inverse * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))),
           
           r0_NoFR = ifelse(is.na(R_se),
                            NA_real_,
                            ifelse((theta*nu*pi) < mu^2,
                                   0,
                                   sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * 1 * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * (sigma_v+mu) * N_h)))))

#names(R0)   
fig_r0_quad_monthly = ggplot(R0_monthly, aes(x = month, y = r0_quadratic)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil R0 quadratic monthly change (1961-2019)",
         x = "Date",
         y = "R0")

ggsave("Figures/fig_r0_quad_monthly.jpg",
       fig_r0_quad_monthly,
       height=4,width=8,scale=1)


fig_r0_briere_monthly = ggplot(R0_monthly, aes(x = month, y = r0_briere)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil R0 briere monthly change (1961-2019)",
         x = "Date",
         y = "R0")

ggsave("Figures/fig_r0_briere_monthly.jpg",
       fig_r0_briere_monthly,
       height=4,width=8,scale=1)


fig_r0_inverse_monthly = ggplot(R0_monthly, aes(x = month, y = r0_inverse)) + 
    geom_line(alpha  = .8) + 
    theme_minimal()+
    stat_smooth(formula = "y ~ x",
                method = "loess") + 
    labs(title = "Brazil R0 inverse monthly change (1961-2019)",
         x = "Date",
         y = "R0")

ggsave("Figures/fig_r0_inverse_monthly.jpg",
       fig_r0_inverse_monthly,
       height=4,width=8,scale=1)

