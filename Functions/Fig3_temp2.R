# load library
library(dplyr)
library(ggplot2)
library(reshape2)
library(viridis)
library(zoo)
library(ggpubr)


load("processedData/R0MeanStatMapNoPrecip.rda")
names(R0MeanStatMap)

df_mean_NoPrecip = R0MeanStatMap %>%
    dplyr::select(
        Longitude,
        Latitude,
        mean_ber_NoPrecip = mean_ber,
        mean_quad_NoPrecip = mean_quad
    )



load("processedData/R0MeanStatMap.rda")
data = R0MeanStatMap %>%
    dplyr::select(
        Longitude,
        Latitude,
        mean_ber,
        mean_quad
    )%>%
    dplyr::left_join(
        df_mean_NoPrecip, by=c("Longitude", "Latitude")
    ) %>%
    dplyr::mutate(
        ber_diff = mean_ber_NoPrecip - mean_ber,
        quad_diff = mean_quad_NoPrecip - mean_quad
    )

summary(data)


plot_Fig3 = function(fun){
    # set Function
    if(fun == "berier"){
        df = data %>%
            dplyr::rename(
                "variable" = ber_diff
            )
    } 
    
    if(fun == "quadratic"){
        df = data %>%
            dplyr::rename(
                "variable" = quad_diff
            )
    } 
    
    custom_colors = c('#fff7ec','#fee8c8','#fdd49e','#fdbb84','#fc8d59','#ef6548','#d7301f','#b30000','#7f0000')
    
    g = ggplot(
        df,
        aes(x = Longitude, y = Latitude, color = variable)
    ) +
        geom_point(size=.1) +
        borders(
            size=.2,
            colour = "black",
            xlim=c(-180, 180),
            ylim=c(-62, 90)
        )+ 
        #scale_color_viridis(discrete = TRUE, option = "D")+
        scale_color_gradient2(low = "#4393c3",
                              mid = '#e0e0e0',
                              high = '#d7301f',
                              na.value = "transparent",
                              limits=c(-2,2))+
        labs(
            title = "Difference the Mean annual R0 calculated with and Without Precipitation",
            x = "",
            y = "",
            color = "No Precip R0 - R0"
            #caption = "(A) Mean annual R0 calculated over the period 1950–2020. (B) R0 peak that represents the largest monthly value over period (1950–2020)"
        ) +
        ylim(c(-62, 90)) +
        theme_minimal()+
        guides(color = guide_legend(override.aes = list(size = 10, shape=15)))+
        theme(
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            strip.text.x = element_text(hjust = 0, margin=margin(l=0)),
            strip.text = element_text(size = 12, angle = 0),
            plot.title = element_text(size = 20)
        )
    
    ggsave(paste0("Figures/fig3map_", fun, ".jpg"),
           g,
           height=5,width=11,scale=1)
}
plot_Fig3(fun = "berier")
plot_Fig3(fun = "quadratic")
