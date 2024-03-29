# load library
library(dplyr)
library(ggplot2)
library(reshape2)

# make a input dataframe

# Define the ranges
temperature_range <- c(-58, 40)
precipitation_range <- c(0, 4061)
r_se_range <- c(0, 1)
p_ae_range <- c(0, 1)

# Number of data points
num_points <- 1000

# Generate sequences of values
temperature_values <- seq(from = temperature_range[1], to = temperature_range[2], length.out = num_points)
precipitation_values <- seq(from = precipitation_range[1], to = precipitation_range[2], length.out = num_points)

# Create a grid of combinations
df = expand.grid(
    t = temperature_values,
    r = precipitation_values
    ) %>%
    dplyr::mutate(
        R_se = 1,
        P_ae = 1
    )


CalculateR0 = function(df){
    
    R0_data = df %>%
        mutate(
            r = (r/2),
            
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
            tw = (.5 * t) + 2,
            
            # Probability of surviving from egg to adult
            # nu = ifelse(t <= 13.56 | t >= 38.29,
            #             0,
            #             -5.99 * 10 ^ (-3) * (t - 38.29) * (t - 13.56)),
            
            # Probability of surviving from egg to adult tw
            nu_tw = ifelse(tw <= 13.56 | tw >= 38.29,
                           0,
                           -5.99 * 10 ^ (-3) * (tw - 38.29) * (tw - 13.56)),
            
            # Rainfall-dependent egg hatching rate the value is zero outside the range. Here the range is daily R>1.18
            # For dR, you may have to divide R by the number of days of the given months (31 for January) ((r*2)/31) (r is divided by 2 before)
            # dR = ifelse(((r*2)/31) >= 1.18,
            #             0,
            #             -2.29574 * (((r*2)/31) ^ 2 - 1.18161 * ((r*2)/31))),
            # 
            dR = 1,
            
            
            # Rate at which an egg develops into an adult mosquito
            # phi = ifelse(t <= 11.36 | t >= 39.17,
            #              0,
            #              7.86 * 10 ^ (-5) * t * (t - 11.36) * sqrt(39.17 - t)),
            
            
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
            # change k/N_H in the base model to 0.975
            K = 0.975, # corrected
            
            N_h = 1, #corrected
            
            #c_briere = 7.86 * 10 ^ (-5),
            #z_briere = .28, 
            #c_quad = -5.99 * 10 ^ (-3),
            #z_quad = 0.025,
           # z_inverse = 0.6,
            # 246 corrected value
            z = 1,
            # rMIN = 1, rMAX = 246
            
            FR_briere = ifelse(r <= 1 | r >= 123,
                               0,
                                r * (r - 1) * sqrt(123 - r) * z),
            
            # rMIN = 1, rMAX = 123
            FR_quad = ifelse(r <= 1 | r >= 123,
                             0,
                              (r - 1) * (r - 123) * z),
            
            
            
            # R0 Model (briere)
            r0_briere = ifelse(is.na(R_se),
                               NA_real_,
                               ifelse(is.infinite(FR_briere) |(theta*nu_tw*phi_tw) < mu^2,
                                      0,
                                      sqrt(
                                          ((b ^ 2) * B_vh * B_hv * sigma_v * R_se * K * FR_briere * P_ae * (1 - (mu^2 / (theta * nu_tw * dR * phi_tw)))) / 
                                              (gamma * mu * (sigma_v + mu) * N_h)
                                      )
                               )
            ),
            
            # R0 Model (quadratic)
            r0_quadratic = ifelse(is.na(R_se),
                                  NA_real_,
                                  ifelse(is.infinite(FR_quad)|(theta*nu_tw*phi_tw) < mu^2,
                                         0,
                                         sqrt(
                                             (b ^ 2 * B_vh * B_hv * sigma_v * R_se * K * FR_quad * P_ae * (1 - (mu^2 / (theta * nu_tw * dR * phi_tw)))) / 
                                                 (gamma * mu * (sigma_v + mu) * N_h)
                                         )
                                  )
            )
        ) %>%
        dplyr::select(
            t,
            r,
            FR_briere,
            FR_quad,
            r0_briere,
            r0_quadratic
        )
    
    return(R0_data)
    
}
# by changing the max value to 123 The highest value for Fr (Briere) 
#is 1.045704 and for Fr (quad) is 0.5570674. which means the z for 
df_out = df %>%
    CalculateR0()

# plot
df_out_r = df_out %>%
    select(r, FR_briere,FR_quad)%>%
    melt(id.vars = 1)%>%
    dplyr::mutate(
        variable = factor(variable)
    )

# Create a combined plot with multiple facets
g = ggplot(df_out_r,
            aes(x = r,
                y = value,
                color = variable,
                group=variable,
                linetype = variable)) +
    geom_line(linewidth=1.2) +
    labs(x = "Precipitation",
         y = "fR() value") +
    xlim(c(0,300))+
    facet_wrap(. ~ variable,
               ncol=1)
    

# Display the combined plot
ggsave("Figures/Precipitaion_analysis_123.jpg",
       g,
       height=6,width=8,scale=1)

