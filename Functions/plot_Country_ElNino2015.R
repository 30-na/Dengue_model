
# load library
library(dplyr)
library(ggplot2)
library(reshape2)
library(viridis)
library(zoo)
library(ggpubr)
library(maps)

# load data
load("processedData/R0_1950to2020.rda")
load("processedData/R0MeanMonthStatMap.rda")



labels = rev(c("< -40", "-40 to -30", "-30 to -20", "-20 to -10", "-10 to 0","0", "0 to 10", "10 to 20", "20 to 30", "30 to 40", "> 40"))
df_map_2015 = R0 %>%
    dplyr::filter(Date >= "2015-02-15" & Date < "2016-02-15") %>%
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




plot_map = function(month, fun, title1, title2, id, cnt){
    if(fun == "berier"){
        temp_df = df_map_2015 %>%
            dplyr::rename(
                "var1" = mean_ber_disc,
                "var2" = per_temp
            )
    }
    
    if(fun == "quadratic"){
        temp_df = df_map_2015 %>%
            dplyr::rename(
                "var1" = mean_quad_disc,
                "var2" = per_temp
            )
    }
    
    temp_df = temp_df %>%
        dplyr::filter(
            Month == month,
            country == cnt
        )
    
    custom_colors = c('#67001f','#b2182b','#d6604d','#f4a582','#fddbc7','#e0e0e0','#d1e5f0','#92c5de','#4393c3','#2166ac','#053061')
    
    
    
    g1 = ggplot(
        temp_df,
        aes(x = Longitude, y = Latitude, fill = var1)
    ) +
        geom_tile() +
        geom_polygon(data = map_data("world", region = cnt),
                     aes(x = long, y = lat, group = group),
                     color = "black",
                     fill = NA,
                     size = 1) +
        # borders(
        #     size=.2,
        #     colour = "black",
        #     xlim = c(115, 127),  # Adjust these values to focus on the Philippines
        #     ylim = c(4, 21)
        # )+
        #scale_color_viridis()+
        scale_fill_manual(values = custom_colors,
                          na.value = "transparent",
                          drop = TRUE,
                          na.translate = F) +
        labs(
            #title = paste0(month, title),
            x = "",
            y = "",
            fill = "R0 (%)"
        )+
        #ylim(c(-62, 90)) +
        
        theme_minimal()+
        guides(color = guide_legend(override.aes = list(size = 8, shape=15)))+
        theme(
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            plot.title = element_text(size = 12)
        )+
        coord_fixed()
    
    
    
    
    g2 = ggplot(
        temp_df,
        aes(x = Longitude, y = Latitude, fill = var2)
    ) +
        geom_tile() + 
        geom_polygon(data = map_data("world", region = cnt), aes(x = long, y = lat, group = group),
                     color = "black", fill = NA, size = 1) +
        # borders(
        #     size=.2,
        #     colour = "black",
        #     xlim = c(115, 127),  # Adjust these values to focus on the Philippines
        #     ylim = c(4, 21)
        # )+ 
        #scale_color_viridis()+
        scale_fill_gradientn(colors = rev(custom_colors),
                             limits = c(-5, 5),
                             #limits = c(-15, 15),
                             na.value = "transparent") +
        labs(
            #title = paste0(month, title),
            x = "",
            y = "",
            fill = "Temperature %"
        )+
        #ylim(c(-62, 90)) +
        
        theme_minimal()+
        #guides(color = guide_legend(override.aes = list(size = 8, shape=15)))+
        theme(
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            plot.title = element_text(size = 12)
        )+
        coord_fixed()
    
    
    g <- ggarrange(g1,
                   g2,
                   labels=c(paste0(month, title1, cnt),
                            paste0(month, title2, cnt)),
                   font.label = list(size = 12,
                                     color = "black",
                                     face = "plain"),
                   ncol = 1,
                   nrow = 2,
                   hjust = -.02)
    
    ggsave(paste0("Figures/month/country/2015/", sprintf("%02d", id),cnt ,month, "_map_month_",fun, ".jpg"),
           g,
           height=9,width=5,scale=1.6)
}


months <- c("February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December", "January" )


for(m in 1:length(months)){
    
    plot_map(month = months[m],
             fun = "berier",
             title1 = " R0 2015-16 El Nino ",
             title2 = " 2015-16 El Nino Temperature differnce with respect to the same month average 1950–2020 ",
             id = m,
             cnt = "Philippines"
    )
}

for(m in 1:length(months)){
    
    plot_map(month = months[m],
             fun = "berier",
             title1 = " R0 2015-16 El Nino ",
             title2 = " 2015-16 El Nino Temperature differnce with respect to the same month average 1950–2020 ",
             id = m,
             cnt = "Brazil"
    )
}

