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

R0_per <- merge(R0MeanYear,
                R0MeanMonthStat %>% dplyr::select(Month, mean_ber, mean_quad),
                by = "Month") %>%
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
    
data2 <- merge(R0_per, ONI, by = c("Year", "Month"))  %>%
    arrange(
        Year,
        Month
    ) %>%
    dplyr::mutate(
        per_ber1 = lead(per_ber, 1),
        per_ber2 = lead(per_ber, 2),
        per_ber3 = lead(per_ber, 3),
        per_quad1 = lead(per_quad, 1),
        per_quad2 = lead(per_quad, 2),
        per_quad3 = lead(per_quad, 3),
        
        per_berb1 = lag(per_ber, 1),
        per_berb2 = lag(per_ber, 2),
        per_berb3 = lag(per_ber, 3),
        per_quadb1 = lag(per_quad, 1),
        per_quadb2 = lag(per_quad, 2),
        per_quadb3 = lag(per_quad, 3)
    )

names(data2)
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


g <- ggarrange(g5, g6,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig12.jpg"),
       g,
       height = 6, width = 12, scale = 1)




g51 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_ber1)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (One Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g61 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_quad1)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (One Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()


g <- ggarrange(g51, g61,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig13.jpg"),
       g,
       height = 6, width = 12, scale = 1)



g52 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_ber2)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (Two Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g62 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_quad2)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (Two Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()


g <- ggarrange(g52, g62,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig14.jpg"),
       g,
       height = 6, width = 12, scale = 1)




g53 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_ber3)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (Three Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g63 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_quad3)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (Three Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()


g <- ggarrange(g53, g63,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig15.jpg"),
       g,
       height = 6, width = 12, scale = 1)


################# one month before

g51 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_berb1)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (One Month before)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g61 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_quadb1)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (One Month before)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()


g <- ggarrange(g51, g61,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig16.jpg"),
       g,
       height = 6, width = 12, scale = 1)



g52 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_berb2)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (Two Month before)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g62 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_quadb2)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (Two Month before)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()


g <- ggarrange(g52, g62,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig17.jpg"),
       g,
       height = 6, width = 12, scale = 1)




g53 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_berb3)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Berier Function (Three Month before)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()

g63 <- ggplot(data = data2, aes(x = ONI_noaa, y = per_quadb3)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index (NOAA)",
        y = "Standardized R0",
        title = "Oceanic El Niño Index (ONI) and Standardized R0 Using Monthly Averages with the Quadratic Function (Three Month before)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data2$per_ber, na.rm = TRUE)) +
    theme_minimal()


g <- ggarrange(g53, g63,
               ncol = 1,
               nrow = 2)

ggsave(paste0("Figures/fig18.jpg"),
       g,
       height = 6, width = 12, scale = 1)



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
data3 <- merge(R0_per_regions, ONI, by = c("Year", "Month")) %>%
    arrange(
        regions,
        Year,
        Month
        ) %>%
    group_by(
        regions
        ) %>%
    dplyr::mutate(
        per_ber1 = lead(per_ber, 1),
        per_ber2 = lead(per_ber, 2),
        per_ber3 = lead(per_ber, 3),
        per_quad1 = lead(per_quad, 1),
        per_quad2 = lead(per_quad, 2),
        per_quad3 = lead(per_quad, 3)
    )




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





g91 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_ber1)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Berier Function (One Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_ber, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig19.jpg"),
       g91,
       height=14,width=10,scale=1)



g101 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_quad1)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Quadratic Function (One Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_quad, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig20.jpg"),
       g101,
       height=14,width=10,scale=1)



g92 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_ber2)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Berier Function (Two Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_ber, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig21.jpg"),
       g92,
       height=14,width=10,scale=1)



g102 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_quad2)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Quadratic Function (Two Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_quad, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig22.jpg"),
       g102,
       height=14,width=10,scale=1)






g93 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_ber3)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Berier Function (Three Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_ber, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig23.jpg"),
       g93,
       height=14,width=10,scale=1)



g103 <- ggplot(data = data3, aes(x = ONI_noaa, y = per_quad3)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Quadratic Function (Three Month later)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_quad, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig24.jpg"),
       g103,
       height=14,width=10,scale=1)




g9NA <- ggplot(data = data3 %>% filter(per_ber < 200), aes(x = ONI_noaa, y = per_ber)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Berier Function (R0 < 200)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_ber, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig25.jpg"),
       g9NA,
       height=14,width=10,scale=1)



g10NA <- ggplot(data = data3 %>% filter(per_ber < 200), aes(x = ONI_noaa, y = per_quad)) +
    geom_point() +
    labs(
        x = "Oceanic El Nino Index",
        y = "Standardized R0",
        title = "Oceanic El Nino Index and Standardized R0 Using Monthly Averages with the Quadratic Function (R0 < 200)"
    ) +
    geom_smooth(method = "lm", formula = y ~ x, se = F) +
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data3$per_quad, na.rm = TRUE)) +
    theme_minimal() + 
    facet_wrap(~ regions, nrow = 7)

ggsave(paste0("Figures/fig26.jpg"),
       g10NA,
       height=14,width=10,scale=1)
