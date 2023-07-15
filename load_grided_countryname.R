
# load library
library(dplyr)
library(geonames)


options(geonamesUsername="30na")

# Create the dataframe
grid_country <- expand.grid(Latitude = seq(-89.75, 89.75, by = 0.5),
                  Longitude = seq(-179.75, 179.75, by = 0.5))

country <- c()  # Initialize the 'country' vector

for (i in 1:nrow(df)) {
    result <- tryCatch(
        {
            geonames::GNcountryCode(lat = grid_country[i, 1], lng = grid_country[i, 2])$countryName
        },
        error = function(e) {
            "Not Found"  # Assign a specific value for locations in the sea
        }
    )
    country[i] <- result
    print(i)
}

grid_country$country = country


save(grid_country,
     file = "processedData/grid_country.rda")







