# load library
library(dplyr)
library(ggplot2)
library(gridExtra)
library(ggpubr)
# load data
load("processedData/temp_cpc.rda")
names(temp_cpc)
cpc <- temp_cpc %>%
    group_by(Year) %>%
    summarise(
        cold = sum(temp == "cold", na.rm = T),
        warm = sum(temp == "warm", na.rm = T),
        elnino = sum(climate == "Elnino", na.rm = T),
        elnina = sum(climate == "Elnina", na.rm = T)
    )
    

load("processedData/R0MeanYearStat.rda")


data <- merge(cpc, R0MeanYearStat, by="Year")


g1 <- ggplot(data = data, aes(x = elnino, y = mean_ber)) +
    geom_point() + 
    geom_text(aes(x = elnino, y = mean_ber, label = Year), vjust = -1, hjust = 1 , alpha=.5, size = 3) +
    labs(
        x = "El Nino Months",
        y = "R0 anomalies",
        title = "Number of El Nino Months in Each Year and R0 Anomalies Using the Berier Function"
    ) +
    xlim(0,12)+
    geom_smooth(method = "lm", formula = y~x, se = F)+
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data$mean_ber)) +
    theme_minimal()

g2 <- ggplot(data = data, aes(x = elnino, y = mean_quad)) +
    geom_point() + 
    geom_text(aes(x = elnino, y = mean_quad, label = Year), vjust = -1, hjust = 1 , alpha=.5, size = 3) +
    labs(
        x = "El Nino Months",
        y = "R0 anomalies",
        title = "Number of El Nino Months in Each Year and R0 Anomalies Using the Quadratic Function"
    ) +
    xlim(0,12)+
    geom_smooth(method = "lm", formula = y~x, se = F)+
    stat_cor(method = "pearson",
             label.x = 1,
             label.y = max(data$mean_quad)) +
    theme_minimal()


g <- ggarrange(g1,
               g2,
               #g1,
               #g1,
               heights = c(1.1,1),
               font.label = list(size = 12,
                                 color = "black",
                                 face = "plain"),
               ncol = 1,
               nrow = 2,
               hjust = -.02)

g = annotate_figure(g,
                    top = text_grob("",
                                    #face = "bold",
                                    size = 20,
                                    hjust=7)
)

g
ggsave(paste0("Figures/fig5.jpg"),
       g,
       height=10,width=12,scale=1)



fit_quad <- lm(mean_quad ~ elnino, data = data)
summary(fit_quad)

fit_ber <- lm(mean_ber ~ elnino, data = data)
summary(fit_ber)

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
    )%>%
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