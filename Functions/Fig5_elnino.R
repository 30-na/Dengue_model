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




##### plot 6
load("processedData/R0MeanMonthStatMap.rda")
load("processedData/R0MeanMonthStat.rda")
load("processedData/R0MeanYear.rda")

R0_per <- merge(R0MeanYear, R0MeanMonthStat %>% dplyr::select(Month, mean_ber, mean_quad), by = "Month") %>%
    rename(
        "mean_ber" = mean_ber.x,
        "mean_quad" = mean_quad.x,
        "mean_ber_total" = mean_ber.y,
        "mean_quad_total" = mean_quad.y,
    ) %>%
    dplyr::mutate(
        diff_ber = mean_ber - mean_ber_total,
        diff_quad = mean_quad - mean_quad_total,
        per_ber = ifelse(diff_ber == 0 & mean_ber_total == 0, 0, (diff_ber / mean_ber_total)*100),
        per_quad = ifelse(diff_quad == 0 & mean_quad_total == 0, 0, (diff_quad / mean_quad_total)*100)
        )
    
data2 <- merge(R0_per, ONI, by = c("Year", "Month"))


# plot for briere
g5 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_ber)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (NOAA)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g6 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_quad)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (NOAA)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()


g7 <- ggplot(data = data2, aes(x = ONI_cpc, y = per_ber)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (CPC)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g8 <- ggplot(data = data2, aes(x = ONI_cpc, y = per_quad)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (CPC)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()
g <- ggarrange(g5, g6,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig12.jpg"),
       g,
       height = 6, width = 10, scale = 1)


#### plot 7)

# merge data and remove NA regions
load("processedData/R0MeanMonthStatRegions.rda")


R0_per_regions <- merge(R0Region, R0MeanMonthStatRegions, by = c("regions", "Month")) %>%
    dplyr::mutate(
        diff_ber = mean_r0_briere - mean_ber_total,
        diff_quad = mean_r0_quad - mean_quad_total,
        per_ber = ifelse(diff_ber == 0 & mean_ber_total == 0, 0, (diff_ber / mean_ber_total)*100),
        per_quad = ifelse(diff_quad == 0 & mean_quad_total == 0, 0, (diff_quad / mean_quad_total)*100)
    )


# merge data and remove NA regions
data3 <- merge(R0_per_regions, ONI, by = c("Year", "Month"))


names(data3)
library(ggplot2)
# plot for briere
g9 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_ber)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Berier Function (NOAA)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_ber, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig9.jpg"),
       g9,
       height=14,width=10,scale=1)



g10 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_quad)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Quadratic Function (NOAA)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_quad, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig10.jpg"),
       g10,
       height=14,width=10,scale=1)

