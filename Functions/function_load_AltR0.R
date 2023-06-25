# load library
library(dplyr)
library(raster)

load("processedData/aegypti.rda")
load("processedData/globalEconomic.rda")

runR0 = function(month) {

  #load data
  load(paste("processedData/World/", month, ".RDA", sep = ""))


  # merge datasets and define the parameters
  R0 = aegypti %>%
        left_join(climate, by = c("x", "y")) %>%
        left_join(globalEconomic, by = c("x", "y")) %>%

        mutate(
              # b = Mosquito biting rate
              b = ifelse(t <= 13.35 | t >= 40.08,
                          0,
                          2.02 * 10 ^ (-4) * t * (t - 13.35) * sqrt(40.08 - t)),
              
              # B_vh = Probability that an infectious mosquito successfully transmits the virus while taking a blood meal from
              # a susceptible human (i.e., transmission rate)
              B_vh = ifelse(t <= 17.05 | t >= 35.83,
                             0,
                             8.49 * 10 ^ (-4) * t * (t - 17.05) * sqrt(35.83 - t)),
              
              # βhv = 4.91E-04*T*(T-12.22)*(37.46-T)^0.5(corrected formula)
              # B_hv = Probability that an infectious human successfully transmits the virus to a biting susceptible mosquito (i.e., infection rate)
              B_hv = ifelse(t <= 12.22 | t >= 37.46,
                             0,
                             4.91 * 10 ^ (-04) * t * (t - 12.22) * sqrt(37.46 - t)),
              
              # Rate at which vectors  become infectious (extrinsic incubation period)
              sigma_v = ifelse(t <= 18.27 | t >= 42.31,
                                0,
                                1.74 * 10 ^ (-4) * t * (t - 18.27) * sqrt(42.31 - t)),

              # number of eggs a female mosquito produces per day
              theta = ifelse(t <= 14.58 | t >= 34.61,
                              0,
                              8.56 * 10 ^ (-3) * t * (t - 14.58) * sqrt(34.61 - t)),

              # t (air) used to generate the temperature of the water (tw).
              # alpha = 0.5, delta = 2
              tw = .5 * t + 2,

              # Probability of surviving from egg to adult
              nu = ifelse(t <= 13.56 | t >= 38.29,
                           0,
                           -5.99 * 10 ^ (-3) * (t - 38.29) * (t - 13.56)),

              # Probability of surviving from egg to adult tw
              nu_tw = ifelse(tw <= 13.56 | tw >= 38.29,
                           0,
                           -5.99 * 10 ^ (-3) * (tw - 38.29) * (tw - 13.56)),

              # Rainfall-dependent egg hatching rate
              dR = -2.29574 * (R ^ 2 - 1.18161 * R),

              # Rate at which an egg develops into an adult mosquito
              phi = ifelse(t <= 11.36 | t >= 39.17,
                           0,
                           7.86 * 10 ^ (-5) * t * (t - 11.36) * sqrt(39.17 - t)),
              
              
              # Rate at which an egg develops into an adult mosquito (tw)
              phi_tw = ifelse(t <= 11.36 | t >= 39.17,
                           0,
                           7.86 * 10 ^ (-5) * tw * (tw - 11.36) * sqrt(39.17 - tw)),

                        
              # Natural Mosquito Death Rate
              mu = ifelse(t <= 11.25 | t >= 37.22,
                           Inf,
                           1 / (-3.02 * 10 ^ (-1) * (t - 11.25) * (t - 37.22))),
              
              # Per capita human recovery rate
              gamma = 1 / 5,
              
              # Maximum Human to Mosquito Ratio: (vector carrying capacity/human population density)
              K = 20, # corrected
              
              N_h = 1, #corrected
              
              c_briere = 7.86 * 10 ^ (-5),
              z_briere = .28, 
              c_quad = -5.99 * 10 ^ (-3),
              z_quad = 0.025,
              z_inverse = 0.6,
  # 246 corrected value

              # rMIN = 1, rMAX = 246
              FR_briere = ifelse(r <= 1 | r >= 246,
                                  0,
                                  c_briere * r * (r - 1) * sqrt(246 - r) * z_briere),

              # rMIN = 1, rMAX = 123
              FR_quad = ifelse(r <= 1 | r >= 123,
                                0,
                                c_quad * (r - 1) * (r - 123) * z_quad),

              FR_inverse = (1 / r) * z_inverse,

              r0_A_briere = ifelse(is.na(R_se),
                                  NA_real_,
                                  ifelse((theta * nu * phi) < (mu ^ 2) | is.infinite(FR_briere),
                                         0,
                                         sqrt(
                                            (b ^ 2 * B_vh * B_hv * sigma_v * R_se * e^((-1*mu) / sigma_v) * theta * nu_tw * dR *  phi_tw * P_ae * FR_briere) / 
                                            (gamma * mu * (sigma_v + mu) * N_h)
                                            )
                                        )
                                  ),
              r0_A_quadratic = ifelse(is.na(R_se),
                                  NA_real_,
                                  ifelse((theta * nu * phi) < (mu ^ 2) | is.infinite(FR_quad),
                                         0,
                                         sqrt(
                                            (b ^ 2 * B_vh * B_hv * sigma_v * R_se * e^((-1*mu) / sigma_v) * theta * nu_tw * dR *  phi_tw * P_ae * FR_quad) / 
                                            (gamma * mu * (sigma_v + mu) * N_h)
                                            )
                                        )
                                  ),
             r0_A_inverse = ifelse(is.na(R_se),
                                  NA_real_,
                                  ifelse((theta * nu * phi) < (mu ^ 2) | is.infinite(FR_inverse),
                                         0,
                                         sqrt(
                                            (b ^ 2 * B_vh * B_hv * sigma_v * R_se * e^((-1*mu) / sigma_v) * theta * nu_tw * dR *  phi_tw * P_ae * FR_inverse) / 
                                            (gamma * mu * (sigma_v + mu) * N_h)
                                            )
                                        )
                                  ),
                                
            ) %>%
            dplyr::select(
                x,
                y,
                r0_A_briere,
                r0_A_quadratic,
                r0_A_inverse)

  save(R0,
         file = paste("processedData/R0_", month, ".rda", sep = ""))

}



monthname = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

for (i in 1:length(monthname)) {
  runR0(monthname[i])
}

#runR0("July")
