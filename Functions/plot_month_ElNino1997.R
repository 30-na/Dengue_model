
# load library
library(dplyr)
library(ggplot2)
library(reshape2)
library(viridis)
library(zoo)
library(ggpubr)


# load data
load("processedData/R0_1950to2020.rda")
load("processedData/R0MeanMonthStatMap.rda")



labels = rev(c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0","0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"))
df_map_1997 = R0 %>%
    dplyr::filter(Date >= "1997-06-15" & Date < "1998-06-15") %>%
    group_by(Month,
             Longitude,
             Latitude)%>%
    dplyr::summarize(
        mean_ber_ElNino = mean(r0_briere, na.rm = T),
        mean_quad_ElNino = mean(r0_quadratic, na.rm = T),
        mean_temp_ElNino = mean(Temperature, na.rm = T)
    ) %>%
    dplyr::left_join(
        R0MeanMonthStatMap , by=c("Longitude","Latitude", "Month")
    ) %>%
    dplyr::mutate(diff_ber = mean_ber_ElNino - mean_ber,
                  diff_quad = mean_quad_ElNino - mean_quad,
                  diff_temp = mean_temp_ElNino - mean_temp,
                  per_ber = ifelse(diff_ber == 0 & mean_ber == 0, 0, (diff_ber / mean_ber)*100),
                  per_quad = ifelse(diff_quad == 0 & mean_quad == 0, 0, (diff_quad / mean_quad)*100),
                  per_temp = ifelse(diff_temp== 0 & mean_temp == 0, 0, (diff_temp / mean_temp)*100),
                  mean_ber_temper = cut(per_ber,
                                        breaks = c(-Inf,-40, -30, -20, -10, 0, 10, 20, 30, 40, Inf),
                                        labels = c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"),
                                        include.lowest = TRUE),
                  mean_quad_temper = cut(per_quad,
                                         breaks = c(-Inf,-40, -30, -20, -10, 0, 10, 20, 30, 40, Inf),
                                         labels = c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"),
                                         include.lowest = TRUE),
                  mean_quad_temper = cut(per_quad,
                                         breaks = c(-Inf,-40, -30, -20, -10, 0, 10, 20, 30, 40, Inf),
                                         labels = c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"),
                                         include.lowest = TRUE),
                  mean_temp_temper = cut(per_temp,
                                         breaks = c(-Inf,-40, -30, -20, -10, 0, 10, 20, 30, 40, Inf),
                                         labels = c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"),
                                         include.lowest = TRUE),
                  mean_ber_disc = factor(ifelse(per_ber  == 0, "0", as.character(mean_ber_temper)),
                                         levels = labels),
                  mean_quad_disc = factor(ifelse(per_quad  == 0, "0", as.character(mean_quad_temper)),
                                          levels =labels),
                  mean_temp_disc = factor(ifelse(per_temp  == 0, "0", as.character(mean_temp_temper)),
                                          levels =labels)
    )




plot_map = function(month, fun, title1, title2, id){
    if(fun == "berier"){
        temp_df = df_map_1997 %>%
            dplyr::rename(
                "var1" = mean_ber_disc,
                "var2" = diff_temp
            )
    }
    
    if(fun == "quadratic"){
        temp_df = df_map_1997 %>%
            dplyr::rename(
                "var1" = mean_quad_disc,
                "var2" = diff_temp
            )
    }
    
    temp_df = temp_df %>%
        dplyr::filter(
            Month == month
        )
    
    custom_colors = c('#67001f','#b2182b','#d6604d','#f4a582','#fddbc7','#e0e0e0','#d1e5f0','#92c5de','#4393c3','#2166ac','#053061')
    custom_colors2 = c('#ffffe5','#fff7bc','#fee391','#fec44f','#fe9929','#ec7014','#cc4c02','#993404','#662506')
    
    
    
    g1 = ggplot(
        temp_df,
        aes(x = Longitude, y = Latitude, color = var1)
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
            #title = paste0(month, title),
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
    
    
    
    
    g2 = ggplot(
        temp_df,
        aes(x = Longitude, y = Latitude, color = var2)
    ) +
        geom_point(size=.1) +
        borders(
            size=.2,
            colour = "black",
            xlim=c(-180, 180),
            ylim=c(-62, 90)
        )+ 
        #scale_color_viridis()+
        scale_color_gradientn(colors = rev(custom_colors),
                              limits = c(-12, 12),
                              na.value = "transparent") +
        labs(
            #title = paste0(month, title),
            x = "",
            y = "",
            color = "Temperature"
        )+
        ylim(c(-62, 90)) +
        
        theme_minimal()+
        #guides(color = guide_legend(override.aes = list(size = 8, shape=15)))+
        theme(
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            plot.title = element_text(size = 12)
        )
    
    
    g <- ggarrange(g1,
                   g2,
                   labels=c(paste0(month, title1),
                            paste0(month, title2)),
                   font.label = list(size = 12,
                                     color = "black",
                                     face = "plain"),
                   ncol = 1,
                   nrow = 2,
                   hjust = -.02)
    
    ggsave(paste0("Figures/month/1997/", sprintf("%02d", id) ,month, "_map_month_",fun, ".jpg"),
           g,
           height=9,width=9,scale=1)
}

months <- c("June", "July", "August", "September", "October", "November", "December",
            "January", "February", "March", "April", "May")


for(m in 1:length(months)){
    
    plot_map(month = months[m],
             fun = "berier",
             title1 = " R0 1997-98 El Nino",
             title2 = " 1997-98 El Nino Temperature differnce with respect to the same month average 1950–2020",
             id = m
    )
}


for(m in 1:length(months)){
    
    plot_map(month = months[m],
             fun = "quadratic",
             title1 = " R0 1997-98 El Nino",
             title2 = " 1997-98 El Nino Temperature differnce with respect to the same month average 1950–2020",
             id = m
    )
}
