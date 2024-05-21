# load library
library(dplyr)
library(ggplot2)
library(gridExtra)
library(ggpubr)


# load data
load("processedData/noaa.rda")
load("processedData/R0Region.rda")
load("processedData/cpc.rda")

ONI <- merge(cpc %>% mutate(ONI_cpc = as.numeric(ONI_cpc)), noaa, by = c("Year", "Month"))

# merge data and remove NA regions
data <- merge(R0Region, ONI, by = c("Year", "Month")) %>%
    filter(!is.na(regions))

# plot for briere
g1 <- ggplot(data = data, aes(x = ONI_noaa, y = mean_r0_briere)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "R0",
        title = "Oceanic El Nino Index and R0 Using the Berier Function (NOAA)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data$mean_r0_briere, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig6.jpg"),
       g1,
       height=14,width=8,scale=1)


# plot for Quadratic
g2 <- ggplot(data = data, aes(x = ONI_noaa, y = mean_r0_quad)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "R0",
        title = "Oceanic El Nino Index and R0 Using the Quadratic Function (NOAA)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data$mean_r0_quad, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig6quad.jpg"),
       g2,
       height=14,width=8,scale=1)

str(data)


# plot for briere
g3 <- ggplot(data = data, aes(x = ONI_cpc, y = mean_r0_briere)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "R0",
        title = "Oceanic El Nino Index and R0 Using the Berier Function (CPC)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data$mean_r0_briere, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig6cpp.jpg"),
       g3,
       height=14,width=8,scale=1)


# plot for Quadratic
g4 <- ggplot(data = data, aes(x = ONI_cpc, y = mean_r0_quad)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "R0",
        title = "Oceanic El Nino Index and R0 Using the Quadratic Function (CPC)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data$mean_r0_quad, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig6quadCPC.jpg"),
       g4,
       height=14,width=8,scale=1)


