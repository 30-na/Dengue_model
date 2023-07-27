
# load library
library(ggplot2)
library(reshape2)
library(dplyr)

#load Data
load("processedData/R0_YearMean_Map_1950to2020.rda")



PAHO = c("Anguilla", "Antigua and Barbuda", "Argentina", "Aruba", "Bahamas", "Barbados and the Eastern Caribbean Countries",
         "Belize", "Bermuda", "BIREME", "Bolivia", "Brazil", "British Virgin Islands", "Canada", "Cayman Islands",
         "Chile", "Colombia", "Costa Rica", "Cuba", "Curaçao", "Dominica", "Dominican Rep.", "Ecuador",
         "El Salvador", "Colonia Escalón", "French Guiana", "Grenada", "Guadeloupe", "Guyana", "Haiti", "Honduras",
         "Jamaica", "Martinique", "Mexico", "Montserrat", "Nicaragua", "Panama", "Paraguay")

SEARO = c("Bangladesh", "Bhutan", "North Korea", "India", "Indonesia", "Maldives",
          "Myanmar", "Nepal", "Sri Lanka", "Thailand", "Timor-Leste")


WPRO = c("American Samoa (USA)", "Australia", "Brunei", "Cambodia", "China",
         "Cook Islands", "Fiji", "French Polynesia (France)", "Guam (USA)", "Hong Kong SAR (China)",
         "Japan", "Kiribati", "Laos", "Macao SAR (China)", "Malaysia",
         "Marshall Islands", "Micronesia, Federated States of", "Mongolia", "Nauru",
         "New Caledonia", "New Zealand", "Niue", "Northern Mariana Islands, Commonwealth of the (USA)",
         "Palau", "Papua New Guinea", "Philippines", "Pitcairn Island (UK)", "South Korea",
         "Samoa", "Singapore", "Solomon Islands", "Tokelau (New Zealand)", "Tonga", "Tuvalu",
         "Vanuatu", "Vietnam", "Wallis and Futuna (France)")


country_list = sort(unique(R0_YearMean_Map$country))
PAHO[!PAHO %in% country_list]
SEARO[!SEARO %in% country_list]
WPRO[!WPRO %in% country_list]


countryList = "Philippines"
# define the function
print_StandardizedR0 = function(countryList, t){
    y_long = R0_YearMean_Map %>% 
        dplyr::filter(
            country %in% countryList
        ) %>%
        dplyr::group_by(
            Year
        ) %>%
        dplyr::summarise(
            mean_temp = mean(mean_temp, na.rm = T),
            mean_prec = mean(mean_prec, na.rm = T),
            mean_ber = mean(mean_ber, na.rm = T),
            mean_quad = mean(mean_quad, na.rm = T)
        )  %>%
        dplyr::mutate(
            temp_diff = mean_temp - mean(mean_temp, na.rm = T),
            prec_diff = mean_prec - mean(mean_prec, na.rm = T),
            ber_diff = mean_ber - mean(mean_ber, na.rm = T),
            quad_diff = mean_quad - mean(mean_quad , na.rm = T)
        ) %>%
        dplyr::select(
            Year, temp_diff, prec_diff, ber_diff, quad_diff
        ) %>%
        reshape2::melt(
            id.vars = "Year"
        )
    
    
    # Create the plot
    g_y <- ggplot(data = y_long,
                  aes(x = Year,
                      y = value,
                      fill = factor(value < 0))) +
        geom_col(col = "#4d4d4d") +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#3288bd")) +
        facet_wrap(~ variable,
                   scale = "free_y",
                   ncol = 1,
                   labeller = as_labeller(c(temp_diff = "Temperature",
                                            prec_diff = "Precipitation",
                                            ber_diff = "R0 (Briere)",
                                            quad_diff = "R0 (Quadratic)"
                                            #ber_alt_diff = "R0 (Briere Alternative)",
                                            #quad_alt_diff = "R0 (Quadratic Alternative)"
                   ))) +
        theme_minimal() +
        labs(title = paste0("Standardized R0 anomalies with respect to 1950-2020 at ", t),
             y = "",
             x = "") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8, face = "bold")) +
        guides(fill = FALSE)
    
    # Print the plots
    ggsave(paste0("Figures/Standardized_R0_1950_", t, ".jpg"),
           g_y,
           height = 9, width = 7, scale = 1)
    
    
}

print_StandardizedR0(countryList = c("Philippines"), t = "Philippines")
print_StandardizedR0(countryList = c("Brazil"), t = "Brazil")
print_StandardizedR0(countryList = c("India"), t = "India")
print_StandardizedR0(countryList = c("Vietnam"), t = "Vietnam")
print_StandardizedR0(countryList = PAHO, t = "PAHO")
print_StandardizedR0(countryList = SEARO, t = "SEARO")
print_StandardizedR0(countryList = WPRO, t = "WPRO")




# define the function for whole world
print_StandardizedR0 = function(){
    y_long = R0_YearMean_Map %>% 
        dplyr::group_by(
            Year
        ) %>%
        dplyr::summarise(
            mean_temp = mean(mean_temp, na.rm = T),
            mean_prec = mean(mean_prec, na.rm = T),
            mean_ber = mean(mean_ber, na.rm = T),
            mean_quad = mean(mean_quad, na.rm = T)
            #mean_ber_alt = mean(r0_A_briere, na.rm = T),
            #mean_quad_alt = mean(r0_A_quadratic, na.rm = T)
        ) %>%
        dplyr::mutate(
            temp_diff = mean_temp - mean(mean_temp, na.rm = T),
            prec_diff = mean_prec - mean(mean_prec, na.rm = T),
            ber_diff = mean_ber - mean(mean_ber, na.rm = T),
            quad_diff = mean_quad - mean(mean_quad , na.rm = T)
            #ber_alt_diff = mean_ber_alt - mean(mean_ber_alt , na.rm = T),
            #quad_alt_diff = mean_quad_alt - mean(mean_quad_alt, na.rm = T)
        ) %>%
        dplyr::select(
            Year, temp_diff:quad_diff
        ) %>%
        reshape2::melt(
            id.vars = "Year"
        )
    
    
    # Create the plot
    g_y <- ggplot(data = y_long,
                  aes(x = Year,
                      y = value,
                      fill = factor(value < 0))) +
        geom_col(col = "#4d4d4d") +
        scale_fill_manual(values = c("FALSE" = "#d6604d", "TRUE" = "#3288bd")) +
        facet_wrap(~ variable,
                   scale = "free_y",
                   ncol = 1,
                   labeller = as_labeller(c(temp_diff = "Temperature",
                                            prec_diff = "Precipitation",
                                            ber_diff = "R0 (Briere)",
                                            quad_diff = "R0 (Quadratic)"
                                            #ber_alt_diff = "R0 (Briere Alternative)",
                                            #quad_alt_diff = "R0 (Quadratic Alternative)"
                   ))) +
        theme_minimal() +
        labs(title = paste0("Standardized R0 anomalies with respect to 1950-2020"),
             y = "",
             x = "") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8, face = "bold")) +
        guides(fill = FALSE)
    
    # Print the plots
    ggsave(paste0("Figures/Standardized_R0_1950.jpg"),
           g_y,
           height = 9, width = 7, scale = 1)
    
    
}

print_StandardizedR0()
