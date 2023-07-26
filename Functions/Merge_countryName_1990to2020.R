library(dplyr)
library(data.table)
library(sf)


# load data
load("processedData/R0_30years.rda")

# Read the data from the CSV file and convert the 'geometry' column to sf object
grid_country <- data.table::fread("custom_grid_with_country_names.csv")
grid_country_sf <- st_as_sf(grid_country,
                            wkt = "geometry",
                            crs = 4326)

grid_country_clean = grid_country %>%
    dplyr::mutate(
        Longitude = st_coordinates(grid_country_sf$geometry)[,1],
        Latitude = st_coordinates(grid_country_sf$geometry)[,2],
        country = ifelse(country_name == "" | country_name == "Antarctica", NA, country_name)
    ) %>%
    dplyr::select(Longitude,
                  Latitude,
                  country)

# merge with last 30 years data
R0 = R0_30years %>%
    dplyr::left_join(grid_country_clean,
                     by=c("Longitude", "Latitude"))


save(R0,
     file = "processedData/R0_30years_countryName.rda")



