# load library
library(dplyr)
library(raster)

load("processedData/aegypti.rda")
load("processedData/globalEconomic.rda")

runR0 = function(month){
    
    #load data
    load(paste("processedData/World/", month , ".RDA" , sep = ""))
    
    
    # merge datasets and define the parameters
    R0 = aegypti %>%
        left_join(climate, by = c("x", "y")) %>%
        left_join(globalEconomic, by = c("x", "y"))%>%
        mutate(b = ifelse(t <= 13.35 | t >= 40.08,
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
               FR_briere = ifelse(r > 246 | r < 0,
                                  0,
                                  c_briere*r*(r-0)*sqrt(246-r)*z_briere),
               
               FR_quad = ifelse(r < 1 | r > 123,
                                1,
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
               
      # R0 = R0 %>%
      #   dplyr::select(x, y, r0_briere, r0_quadratic, r0_inverse)
    
    save(R0,
         file = paste("processedData/R0_", month, ".rda", sep=""))
    
}



# monthname = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
# 
# for(i in 1:length(monthname)){
#     runR0(monthname[i])
# }

runR0("July")



           