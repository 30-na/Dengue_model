
# load library
library(ggplot2)
library(reshape2)
library(dplyr)

# load data
load("R0YearStat.rda")
load("R0MonthStat.rda")

# make a long data


y_long = R0YearStat %>% 
    dplyr::filter(
        Year >= 1990 & Year <= 2020
        ) %>%
    dplyr::mutate(
        temp_diff = mean_temp - mean(mean_temp, na.rm = T),
        prec_diff = mean_prec - mean(mean_prec, na.rm = T),
        ber_diff = mean_ber - mean(mean_ber, na.rm = T),
        quad_diff = mean_quad - mean(mean_quad , na.rm = T),
        ber_alt_diff = mean_ber_alt - mean(mean_ber_alt , na.rm = T),
        quad_alt_diff = mean_quad_alt - mean(mean_quad_alt, na.rm = T)
        )%>%
    dplyr::select(
        Year, temp_diff:quad_alt_diff
        ) %>%
    reshape2::melt()


names(R0YearStat)

# Create the plot
g_y <- ggplot(data = y_long, aes(x = Year, y = value, fill = factor(value < 0))) +
    geom_col(col = "gray") +
    scale_fill_manual(values = c("FALSE" = "red", "TRUE" = "steelblue")) +
    facet_wrap(~ variable,
               scale = "free_y",
               ncol = 1,
               labeller = as_labeller(c(temp_diff = "Temperature",
                                        prec_diff = "Precipitation",
                                        ber_diff = "R0 (Briere)",
                                        quad_diff = "R0 (Quadratic)",
                                        ber_alt_diff = "R0 (Briere Alternative)",
                                        quad_alt_diff = "R0 (Quadratic Alternative)"))) +
    theme_minimal() +
    labs(title = "Standardized R0 anomalies with respect to 1990-2020",
         y = "",
         x = "") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 10, face = "bold")) +
    guides(fill = FALSE)

# Print the plots
ggsave("Figures/year_diff.jpg",
       g_y,
       height = 12, width = 8, scale = 1)
