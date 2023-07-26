
# load library
library(dplyr)
library(ggplot2)
library(viridis)
library(RColorBrewer)


# load data
load("processedData/R0_mean.rda")


R0.mean.total = R0.mean %>%
    dplyr::group_by(
        Longitude,
        Latitude
    ) %>%
    dplyr::summarize(
        mean_temp = mean(mean_temp, na.rm = T),
        mean_prec = mean(mean_prec, na.rm = T),
        mean_ber = mean(mean_ber, na.rm = T),
        mean_quad = mean(mean_quad, na.rm = T)
    ) %>%
    dplyr::mutate(
        interval = "1990-2020"
    )


plot_map = function(var, target_year){
    
R0.mean.year = R0.mean %>%
    dplyr::filter(
        Year == target_year
    ) %>%
    dplyr::mutate(
        interval = as.character(target_year)
    )


merged_data = rbind(
    R0.mean.total,
    R0.mean.year
)

    g = ggplot(
        merged_data,
        aes_string(x = "Longitude", y = "Latitude", color = var)
        ) +
        geom_point() +
        borders(
            size=.5,
            colour = "black"
        )+ 
        scale_color_viridis(
            option = "magma",
            direction = -1,
            na.value = "white"
            ) +
        labs(
            title = "Mean Annual R0 Calculated Over the Period 1990–2020)",
            x = "",
            y = ""
            ) +
        facet_wrap(
            . ~ interval,
            ncol = 1
            ) +
        ylim(
            c(-62,90)
            )+
        theme_minimal()
    
    ggsave(paste0("Figures/", var, target_year, ".jpg"),
           g,
           height=8,width=7,scale=1.65)
}

plot_map("mean_quad", 2015)


## plot map diff
R0.mean.diff = R0.mean %>%
    dplyr::group_by(
        Longitude,
        Latitude
    ) %>%
    dplyr::mutate(
        mean_temp_total = mean(mean_temp, na.rm = T),
        mean_prec_total = mean(mean_prec, na.rm = T),
        mean_ber_total = mean(mean_ber, na.rm = T),
        mean_quad_total = mean(mean_quad, na.rm = T),
        mean_temp_diff = mean_temp - mean_temp_total,
        mean_prec_diff = mean_prec - mean_prec_total,
        mean_ber_diff = mean_ber - mean_ber_total,
        mean_quad_diff = mean_quad - mean_quad_total,
        mean_ber_diff_disc = cut(mean_ber_diff,
                                  breaks = c(-Inf, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, Inf),
                                  labels = c("1.5-",
                                             "-1.5 to -1",
                                             "-1 to -0.5",
                                             "-0.5 to 0",
                                             "0 to 0.5",
                                             "0.5 to 1",
                                             "1 to 1.5",
                                             "1.5+"),
                                  include.lowest = TRUE),
        mean_quad_diff_disc = cut(mean_quad_diff,
                                  breaks = c(-Inf, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, Inf),
                                  labels = c("1.5-",
                                             "-1.5 to -1",
                                             "-1 to -0.5",
                                             "-0.5 to 0",
                                             "0 to 0.5",
                                             "0.5 to 1",
                                             "1 to 1.5",
                                             "1.5+"),
                                  include.lowest = TRUE)
    )


plot_map_diff = function(var, tragetYear, model){
    
    g = ggplot(
        R0.mean.diff %>% dplyr::filter(Year == tragetYear),
        aes_string(x = "Longitude", y = "Latitude", color = var)
    ) +
        geom_point() +
        borders(
            size=.5,
            colour = "black"
        )+ 
        # scale_color_gradient2(
        #     low = "#313695",
        #     mid = "#ffffbf",
        #     high = "#a50026",
        #     midpoint = 0,
        #     na.value = "white",
        #     limits = c(-1.5, 1.5)
        #     ) +
        scale_color_gradientn(colors = rev(brewer.pal(5, "RdYlBu")),
                              na.value = "white",
                              limits = c(-1.5, 1.5)) +
        labs(
            title = paste0("Relative R0 Values in ",
                           tragetYear,
                           " Compared to Mean annual R0 Over 1990 to 2020 (",
                           model, 
                           ")"),
            x = "",
            y = "",
            color = "Relative R0"
        ) +
        ylim(
            c(-62,90)
        )+
        theme_minimal()+
        theme(
            legend.position = "right",  # Change the legend position (options: "none", "right", "bottom", "top", or a numeric vector c(x, y))
            legend.title = element_text(size = 12, face = "bold"),  # Customize legend title text
            title = element_text(size = 12, face = "bold"),
            legend.text = element_text(size = 10)  # Customize legend text
            # Add more theme elements as needed to further customize the appearance of the plot
        )
    
    ggsave(paste0("Figures/", var, tragetYear, ".jpg"),
           g,
           height=4,width=8,scale=1.65)
}

plot_map_diff(var = "mean_ber_diff", tragetYear = 1997, model = "Briere")
plot_map_diff(var = "mean_ber_diff", tragetYear = 1998, model = "Briere")
plot_map_diff(var = "mean_ber_diff", tragetYear = 2002, model = "Briere")
plot_map_diff(var = "mean_ber_diff", tragetYear = 2010, model = "Briere")
plot_map_diff(var = "mean_ber_diff", tragetYear = 2015, model = "Briere")
plot_map_diff(var = "mean_ber_diff", tragetYear = 2016, model = "Briere")
plot_map_diff(var = "mean_quad_diff", tragetYear = 1997, model = "Quadratic")
plot_map_diff(var = "mean_quad_diff", tragetYear = 1998, model = "Quadratic")
plot_map_diff(var = "mean_quad_diff", tragetYear = 2002, model = "Quadratic")
plot_map_diff(var = "mean_quad_diff", tragetYear = 2010, model = "Quadratic")
plot_map_diff(var = "mean_quad_diff", tragetYear = 2015, model = "Quadratic")
plot_map_diff(var = "mean_quad_diff", tragetYear = 2016, model = "Quadratic")


