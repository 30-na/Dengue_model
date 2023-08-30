
library(dplyr)
library(ggplot2)
library(ggpubr)
library(zoo)
library(reshape2)


load("processedData/R0MeanYearStatNoPrecip.rda")
df_mean_NoPrecip = R0MeanYearStat %>%
    dplyr::select(
        Year,
        mean_ber_NoPrecip = mean_ber,
        mean_quad_NoPrecip = mean_quad
    )%>%
    dplyr::filter(
        Year <= 2020
    )



load("processedData/R0MeanYearStat.rda")
names(R0MeanYearStat)
data = R0MeanYearStat %>%
    dplyr::select(
        Year,
        mean_ber,
        mean_quad,
        mean_temp
    )%>%
    dplyr::left_join(
        df_mean_NoPrecip, by=c("Year")
    )%>%
    dplyr::mutate(
        diff_ber = mean_ber_NoPrecip - mean_ber,
        diff_quad = mean_quad_NoPrecip - mean_quad,
        per_ber = (diff_ber / mean_ber)*100,
        per_quad = (diff_quad / mean_quad)*100,
        per_ber_smooth = rollmean(per_ber,
                                  k = 5,
                                  fill = NA,
                                  align = "center"),
        per_quad_smooth = rollmean(per_quad,
                                   k = 5,
                                   fill = NA,
                                   align = "center"),
        NoPrecip_ber_smooth = rollmean(mean_ber_NoPrecip,
                                  k = 5,
                                  fill = NA,
                                  align = "center"),
        NoPrecip_quad_smooth = rollmean(mean_quad_NoPrecip,
                                   k = 5,
                                   fill = NA,
                                   align = "center"),
        temp_smooth = rollmean(mean_temp,
                                       k = 5,
                                       fill = NA,
                                       align = "center")
    )

names(data)
plot_Fig3 = function(title1, title2){
    g1 <- ggplot(data = data,
                 aes(x = as.numeric(Year),
                     y = per_ber)) +  # Remove fill aesthetic from here
        geom_col(col = "white", fill = "#4393c3") +  # Specify fill for geom_col
        geom_line(aes(y = per_ber_smooth),
                  col = "black",
                  size = 1) +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#4393c3")) +
        theme_minimal() +
        labs(#title = title1,
            y = "R0 %",
            x = "") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8, face = "bold")) +
        guides(fill = FALSE) +
        scale_x_continuous(
            breaks = seq(1950, 2020, by = 5),
            labels = seq(1950, 2020, by = 5)) +
        ylim(0,61)
    
    
    
    g2 <- ggplot(data = data,
                 aes(x = as.numeric(Year),
                     y = per_quad)) +  # Remove fill aesthetic from here
        geom_col(col = "white", fill = "#4393c3") +  # Specify fill for geom_col
        geom_line(aes(y = per_quad_smooth),
                  col = "black",
                  size = 1) +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#4393c3")) +
        theme_minimal() +
        labs(#title = title2,
             y = "R0 %",
             x = "") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8, face = "bold")) +
        guides(fill = FALSE) +
        scale_x_continuous(
            breaks = seq(1950, 2020, by = 5),
            labels = seq(1950, 2020, by = 5)) +
        ylim(0,61)
    
    
    
    g <- ggarrange(g1,
                   g2,
                   labels=c(title1,
                            title2),
                   heights = c(1,1),
                   font.label = list(size = 12,
                                     color = "black",
                                     face = "plain"),
                   ncol = 1,
                   nrow = 2,
                   hjust = -.02,
                   align = "hv")
    
    g = annotate_figure(g,
                        top = text_grob("",
                                        #face = "bold",
                                        size = 20)
    )
    
    
    ggsave(paste0("Figures/fig3.jpg"),
           g,
           height=8,width=12,scale=1)
}

plot_Fig3(title1 = "A) Relative Differences of R0 Without Precipitation with respect to R0 With Precipitation (Briere)",
          title2 = "B) Relative Differences of R0 Without Precipitation with respect to R0 With Precipitation (Quadratic)")



plot_Fig5 = function(fun, title1, title2){
    
    if(fun == "briere"){
        df = data %>%
            dplyr::rename(
                "variable1" = mean_ber_NoPrecip,
                "variable2" = NoPrecip_ber_smooth
            )
    } 
    print(df)
    if(fun == "quadratic"){
        df = data %>%
            dplyr::rename(
                "variable1" = mean_quad_NoPrecip,
                "variable2" = NoPrecip_quad_smooth
            )
    } 
    
    
    g1 <- ggplot(data = data,
                 aes(x = as.numeric(Year),
                     y = variable1)) +  # Remove fill aesthetic from here
        geom_col(col = "white", fill = "#4393c3") +  # Specify fill for geom_col
        geom_line(aes(y = per_ber_smooth),
                  col = "black",
                  size = 1) +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#4393c3")) +
        theme_minimal() +
        labs(#title = title1,
            y = "R0",
            x = "") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8, face = "bold")) +
        guides(fill = FALSE) +
        scale_x_continuous(
            breaks = seq(1950, 2020, by = 5),
            labels = seq(1950, 2020, by = 5))
    
    
    
    g2 <- ggplot(data = data,
                 aes(x = as.numeric(Year),
                     y = mean_temp)) +  # Remove fill aesthetic from here
        geom_col(col = "white", fill = "#4393c3") +  # Specify fill for geom_col
        geom_line(aes(y = temp_smooth),
                  col = "black",
                  size = 1) +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#4393c3")) +
        theme_minimal() +
        labs(#title = title2,
            y = "Temperature",
            x = "") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8, face = "bold")) +
        guides(fill = FALSE) +
        scale_x_continuous(
            breaks = seq(1950, 2020, by = 5),
            labels = seq(1950, 2020, by = 5))
    
    
    
    g <- ggarrange(g1,
                   g2,
                   labels=c(title1,
                            title2),
                   heights = c(1,1),
                   font.label = list(size = 12,
                                     color = "black",
                                     face = "plain"),
                   ncol = 1,
                   nrow = 2,
                   hjust = -.02,
                   align = "hv")
    
    g = annotate_figure(g,
                        top = text_grob("",
                                        #face = "bold",
                                        size = 20)
    )
    
    
    ggsave(paste0("Figures/fig5_",fun, ".jpg"),
           g,
           height=8,width=12,scale=1)
}

plot_Fig5(fun="briere",
          title1 = "A) Relative Differences of R0 Without Precipitation with respect to R0 With Precipitation (Briere)",
          title2 = "B) Relative Differences of R0 Without Precipitation with respect to R0 With Precipitation (Quadratic)")



