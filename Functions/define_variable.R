
# Mosquito biting rate
b = 2.02*10^(-4)*t*(t-13.35)*sqrt(40.08-t)
    
# Betha_vh Probability that an infectious mosquito successfully transmits the virus while taking a blood meal from a susceptible human (i.e., transmission rate)
B_vh = 8.49*10^(-4)*t*(t-17.05)*sqrt(35.83-t)

# Betha_hv Probability that an infectious human successfully transmits the virus to a biting susceptible mosquito (i.e., infection rate)
B_hv = -3.54*10^(-3)*(t-38.38)*(t-22.72)

# Rate at which vectors become infectious (extrinsic incubation period)
sigma_v = 1.74*10^(-4)*t*(t-18.27)*sqrt(42.31-t)

# theta # of eggs a female mosquito produces per day
theta = 8.56*10^(-3)*t*(t-14.58)*sqrt(34.61-t)

# Nu Probability of surviving from egg to adult
nu = -5.99*10^(-3)*(t-38.29)*(t-13.56)

# Phi Rate at which an egg develops into an adult mosquito
pi = 7.86*10^(-5)*t*(t-11.36)*sqrt(39.17-t)

# Mu Natural Mosquito Death Rate
mu = 1/(-3.02*10^(-1)*(t-11.25)*(t-37.22))

# Gamma Per capita human recovery rate
gamma = 1/5

# Kappa Carrying Capacity (Maximum # of mosquitos a site can support)
# K = 1.985*10^(6)
# for world map
K = 1000

# Human Population Density
# for world map
N_h = 1

# Risk of exposure


# r0 Formula
r0 = sqrt((b^2 * B_vh * B_hv * sigma_v * R_se * K * FR_briere * P_ae * (1-(mu^2/(theta*nu*pi))))/(gamma * mu * sigma_v+mu * N_h))








