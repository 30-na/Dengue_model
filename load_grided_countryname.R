
# load library
library(dplyr)
library(geonames)


options(geonamesUsername="30na")

# load data
load("processedData/R0_30years.rda")

grid_data = R0_30years %>%
    mutate(
        na_res = is.na(Temperature)
        )%>%
    dplyr::select(
        Longitude, Latitude, na_res
        )%>%
    dplyr::slice(
        1:(720*360)
    )
    
na_list = which(grid_data$na_res == FALSE)


country = character(720*360)


for (i in na_list) {
    result <- tryCatch(
        {
            geonames::GNcountryCode(lat = grid_data[i, 2], lng = grid_data[i, 1])$countryName
        },
        error = function(e) {
            "Not Found"  # Assign a specific value for locations in the sea
        }
    )
    country[i] <- result
}

grid_country = grid_data %>%
    dplyr::mutate(
        country = ifelse(na_res, NA, country)
    )


save(grid_country,
     file = "processedData/grid_country.rda")



