
# load library
library(dplyr)
library(ggplot2)
library(reshape2)
library(viridis)
library(zoo)
library(ggpubr)


# load data
load("processedData/R0_1950to2020.rda")
load("processedData/R0MeanStatMap.rda")
load("processedData/R0MeanYearStat.rda")


df_map_1997 = R0 %>%
    dplyr::filter(Date >= "1997-06-15" & Date < "1998-06-15") %>%
    group_by(Longitude,
             Latitude)%>%
    dplyr::summarize(
    mean_ber_1year = mean(r0_briere, na.rm = T),
    mean_quad_1year = mean(r0_quadratic, na.rm = T)
    ) %>%
    dplyr::left_join(
        R0MeanStatMap , by=c("Longitude","Latitude")
    ) %>%
    dplyr::select(
        Longitude,
        Latitude,
        mean_ber_1year,
        mean_quad_1year,
        mean_ber,
        mean_quad
    ) %>%
    dplyr::mutate(diff_ber = mean_ber_1year - mean_ber,
                  diff_quad = mean_quad_1year - mean_quad,
                  per_ber = ifelse(diff_ber == 0 & mean_ber ==0, 0, (diff_ber / mean_ber)*100),
                  per_quad = ifelse(diff_quad == 0 & mean_quad ==0, 0, (diff_quad / mean_quad)*100),
                  mean_ber_disc = cut(per_ber,
                                      breaks = c(-Inf,-40, -30, -20, -10, 0, 10, 20, 30, 40, Inf),
                                      labels = c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"),
                                      include.lowest = TRUE))




df_map_2015 = R0 %>%
    dplyr::filter(Date >= "2015-02-15" & Date < "2015-02-15") %>%
    group_by(Longitude,
             Latitude)%>%
    dplyr::summarize(
        mean_ber_1year = mean(r0_briere, na.rm = T),
        mean_quad_1year = mean(r0_quadratic, na.rm = T)
    ) %>%
    dplyr::left_join(
        R0MeanStatMap , by=c("Longitude","Latitude")
    ) %>%
    dplyr::select(
        Longitude,
        Latitude,
        mean_ber_1year,
        mean_quad_1year,
        mean_ber,
        mean_quad
    ) %>%
    dplyr::mutate(diff_ber = mean_ber_1year - mean_ber,
                  diff_quad = mean_quad_1year - mean_quad,
                  per_ber = ifelse(diff_ber == 0 & mean_ber ==0, 0, (diff_ber / mean_ber)*100),
                  per_quad = ifelse(diff_quad == 0 & mean_quad ==0, 0, (diff_quad / mean_quad)*100),
                  mean_ber_disc = cut(per_ber,
                                      breaks = c(-Inf,-40, -30, -20, -10, 0, 10, 20, 30, 40, Inf),
                                      labels = c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"),
                                      include.lowest = TRUE))




df_mean = R0MeanYearStat %>% 
    dplyr::mutate(
        total_mean_ber = mean(mean_ber, na.rm = T),
        total_mean_quad = mean(mean_quad, na.rm = T),
        ber_diff = mean_ber - total_mean_ber,
        quad_diff = mean_quad - total_mean_quad,
        ber_per = (ber_diff / total_mean_ber)*100,
        quad_per = (quad_diff / total_mean_quad)*100,
        ber_per_smooth = rollmean(ber_per,
                                  k = 5,
                                  fill = NA,
                                  align = "center"),
        quad_per_smooth = rollmean(quad_per,
                                  k = 5,
                                  fill = NA,
                                  align = "center")
    )




plot_Fig2 = function(title1, title2, ElNinoYear, fun){
    
    custom_colors = rev(c('#67001f','#b2182b','#d6604d','#f4a582','#fddbc7','#d1e5f0','#92c5de','#4393c3','#2166ac','#053061'))
   # custom_colors = c('#74add1','#abd9e9','#e0f3f8','#ffffbf','#fec44f','#fe9929','#cc4c02','#993404','#662506')
    
    # set El Nino Year
    if(ElNinoYear==1997){
        dftemp1 = df_map_1997
    } 
    if(ElNinoYear==2015){
        dftemp1 = df_map_2015
    }
    
    # set Function
    if(fun == "berier"){
        dftemp1 = dftemp1 %>%
            dplyr::rename("var" = mean_ber_disc)
        dftemp2 = df_mean %>%
            dplyr::rename("var" = ber_per)
        mainTitle = "Fig .2"
    } 
    
    if(fun == "quadratic"){
        dftemp1 = dftemp1 %>%
            dplyr::rename("var" = mean_quad_disc)
        dftemp2 = df_mean %>%
            dplyr::rename("var" = quad_per)
        mainTitle = "Fig .2 (Quadratic)"
    } 
    
    g1 = ggplot(
        dftemp1,
        aes(x = Longitude, y = Latitude, color = var)
    ) +
        geom_point(size=.1) +
        borders(
            size=.2,
            colour = "black",
            xlim=c(-180, 180),
            ylim=c(-62, 90)
        )+ 
        #scale_color_viridis()+
        scale_color_manual(values = custom_colors,
                           na.value = "transparent",
                           drop = TRUE,
                           na.translate = F) +
        labs(
            #title = title1,
            x = "",
            y = "",
            color = "R0 (%)"
        )+
        ylim(c(-62, 90)) +
        
        theme_minimal()+
        guides(color = guide_legend(override.aes = list(size = 8, shape=15)))+
        theme(
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            plot.title = element_text(size = 12)
        )
    
    
    g2 <- ggplot(data = df_mean,
                 aes(x = as.numeric(Year),
                     y = var)) +  # Remove fill aesthetic from here
        geom_col(aes(fill = factor(var < 0)), col = "#4d4d4d") +  # Specify fill for geom_col
        geom_line(aes(y = ber_per_smooth),
                  col = "black",
                  size = 1) +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#4393c3")) +
        theme_minimal() +
        labs(#title = title2,
             y = "Standardized R0 anomalies (%)",
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
                   font.label = list(size = 12,
                                     color = "black",
                                     face = "plain"),
                   ncol = 1,
                   nrow = 2,
                   hjust = -.02)
    
    g = annotate_figure(g,
                    top = text_grob(mainTitle,
                                    #face = "bold",
                                    size = 20,
                                    hjust=6.3)
                    )
    
    ggsave(paste0("Figures/fig2_", fun, ".jpg"),
           g,
           height=9,width=9,scale=1)
}

plot_Fig2(title1 = "(A) Annual R0 1997-98 El Nino anomaly (percentage) with respect to the 1950–2020 period",
          title2 = "(B) Standardized R0 anomalies with respect to the 1950–2015 period",
          ElNinoYear = 1997,
          fun = "berier")



plot_Fig2 = function(title1, title2){
    
    custom_colors = rev(c('#67001f','#b2182b','#d6604d','#f4a582','#fddbc7','#d1e5f0','#92c5de','#4393c3','#2166ac','#053061'))
    # custom_colors = c('#74add1','#abd9e9','#e0f3f8','#ffffbf','#fec44f','#fe9929','#cc4c02','#993404','#662506')
    
    g1 = ggplot(
        df_map_1997,
        aes(x = Longitude, y = Latitude, color = mean_quad_disc)
    ) +
        geom_point(size=.1) +
        borders(
            size=.2,
            colour = "black",
            xlim=c(-180, 180),
            ylim=c(-62, 90)
        )+ 
        #scale_color_viridis()+
        scale_color_manual(values = custom_colors,
                           na.value = "transparent",
                           drop = TRUE,
                           na.translate = F) +
        labs(
            #title = title1,
            x = "",
            y = "",
            color = "R0 (%)"
        )+
        ylim(c(-62, 90)) +
        
        theme_minimal()+
        guides(color = guide_legend(override.aes = list(size = 8, shape=15)))+
        theme(
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            plot.title = element_text(size = 12)
        )
    
    
    g2 <- ggplot(data = df_mean,
                 aes(x = as.numeric(Year),
                     y = ber_per)) +  # Remove fill aesthetic from here
        geom_col(aes(fill = factor(ber_per < 0)), col = "#4d4d4d") +  # Specify fill for geom_col
        geom_line(aes(y = ber_per_smooth),
                  col = "black",
                  size = 1) +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#4393c3")) +
        theme_minimal() +
        labs(#title = title2,
            y = "Standardized R0 anomalies (%)",
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
                   font.label = list(size = 12,
                                     color = "black",
                                     face = "plain"),
                   ncol = 1,
                   nrow = 2,
                   hjust = -.02)
    
    g = annotate_figure(g,
                        top = text_grob("Fig. 2",
                                        #face = "bold",
                                        size = 20,
                                        hjust=6.3)
    )
    
    ggsave("Figures/fig2.jpg",
           g,
           height=9,width=9,scale=1)
}

plot_Fig2s(title1 = "(A) Annual R0 2015-16 El Nino anomaly (percentage) with respect to the 1950–2020 period",
          title2 = "(B) Standardized R0 anomalies with respect to the 1950–2015 period")

