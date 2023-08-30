
library(dplyr)
library(ggplot2)
library(ggpubr)
library(zoo)
library(reshape2)


load("processedData/R0MeanYearStatNoPrecip.rda")
df_mean_NoPrecip = R0MeanYearStat %>%
    dplyr::mutate(
        total_mean_ber_NoPrecip = mean(mean_ber, na.rm = T),
        total_mean_quad_NoPrecip = mean(mean_quad, na.rm = T),
        ber_diff_NoPrecip = mean_ber - total_mean_ber_NoPrecip,
        quad_diff_NoPrecip = mean_quad - total_mean_quad_NoPrecip,
        ber_per_NoPrecip = (ber_diff_NoPrecip / total_mean_ber_NoPrecip)*100,
        quad_per_NoPrecip = (quad_diff_NoPrecip / total_mean_quad_NoPrecip)*100
        )%>%
    dplyr::select(
        Year,
        ber_per_NoPrecip,
        quad_per_NoPrecip
        )%>%
    dplyr::filter(
        Year <= 2020
        )
    


load("processedData/R0MeanYearStat.rda")
names(R0MeanYearStat)
data = R0MeanYearStat %>%
    dplyr::mutate(
        total_mean_ber = mean(mean_ber, na.rm = T),
        total_mean_quad = mean(mean_quad, na.rm = T),
        total_mean_temp = mean(mean_temp, na.rm = T),
        total_mean_prec = mean(mean_prec, na.rm = T),
        
        ber_diff = mean_ber - total_mean_ber,
        quad_diff = mean_quad - total_mean_quad,
        temp_diff = mean_temp - total_mean_temp,
        prec_diff = mean_prec - total_mean_prec,
        
        ber_per = (ber_diff / total_mean_ber)*100,
        quad_per = (quad_diff / total_mean_quad)*100,
        temp_per = (temp_diff / total_mean_temp)*100,
        prec_per = (prec_diff / total_mean_prec)*100
        ) %>%
    dplyr::select(
        Year,
        ber_per,
        quad_per,
        temp_per,
        prec_per
        )%>%
    dplyr::left_join(
        df_mean_NoPrecip, by=c("Year")
        )%>%
    reshape2::melt(
        id.vars = "Year"
        )%>%
    group_by(
        variable
        )%>%
    dplyr::mutate(
        smooth_value = rollmean(value,
                                k = 5,
                                fill = NA,
                                align = "center")
    )
    

plot_Fig2 = function(fun){
    
    # set Function
    if(fun == "berier"){
        df = data %>%
            dplyr::filter(
                variable %in% c("ber_per",
                                "temp_per",
                                "prec_per",
                                "ber_per_NoPrecip")
            )
    } 
    
    if(fun == "quadratic"){
        df = data %>%
            dplyr::filter(
                variable %in% c("quad_per",
                                "temp_per",
                                "prec_per",
                                "quad_per_NoPrecip")
            )
    } 
    
    
    g <- ggplot(data = df,
                 aes(x = as.numeric(Year),
                     y = value,
                     fill = variable)) +  
        geom_bar(stat = "identity", position = "dodge", alpha=.8, width = 0.85, col="black", size=.02) +  
        geom_line(aes(y = smooth_value,
                      col = variable),
                  size = 1) +
        #scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#4393c3")) +
        theme_minimal() +
        labs(title = paste("Fig. S3) Impact of Precipitation on", fun, "Model"),
            y = "Standardized R0 anomalies (%)",
            x = "") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8, face = "bold"),
              legend.position = "bottom") +
        
        scale_x_continuous(
            breaks = seq(1950, 2020, by = 5),
            labels = seq(1950, 2020, by = 5))+
        scale_fill_brewer(
            palette = "Dark2",
            guide = guide_legend(
                title = ""
            )
        )+
        scale_color_brewer(palette = "Dark2") +
        guides()
    

    ggsave(paste0("Figures/fig3s", fun, ".jpg"),
           g,
           height=6,width=16,scale=1)
}

plot_Fig2(fun = "berier")
plot_Fig2(fun = "quadratic")

