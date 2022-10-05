# load library



e = exp(1)
f_R = 1/

# Betha_vh Probability that an infectious mosquito successfully transmits the virus while taking a blood meal from a susceptible human (i.e., transmission rate)
B_vh = 8.49*10^(-4)*T*(T-17.05)*sqrt(35.83-T)

# Betha_hv Probability that an infectious human successfully transmits the virus to a biting susceptible mosquito (i.e., infection rate)
B_hv = -3.54*10^(-3)*(T-38.38)*(T-22.72)

# Rate at which vectors become infectious (extrinsic incubation period)
sigma_v = 1.74*10^(-4)*T*(T-18.27)*sqrt(42.31-T)

# theta # of eggs a female mosquito produces per day
theta = 8.56*10^(-3)*T*(T-14.58)*sqrt(34.61-T)

# Nu Probability of surviving from egg to adult
v = -5.99*10^(-3)*(T-38.29)*(T-13.56)

# Phi Rate at which an egg develops into an adult mosquito
pi = 7.86*10^(-5)*T*(T-11.36)*sqrt(39.17-T)

# Mu Natural Mosquito Death Rate
mu = 1/(-3.02*10^(-1)*(T-11.25)*(T-37.22))

# Gamma Per capita human recovery rate
gamma = 1/5

