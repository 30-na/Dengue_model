# Load libraries
library(ggplot2)
library(ncdf4)
library(viridis)
library(dplyr)

# Open the NetCDF file
nc_data <- nc_open("Data/air.mon.mean.v501.nc")

# Get the variable name and dimensions
variable_name <- "air"
lon <- ncvar_get(nc_data, "lon")
lat <- ncvar_get(nc_data, "lat")
time <- ncvar_get(nc_data, "time")
nlon <- dim(lon)
nlat <- dim(lat)
ntime <- dim(time)

# Read the variable data
variable_data <- ncvar_get(nc_data, variable_name)

# Reshape the data to a long format
df <- data.frame(lon = rep(lon, nlat),
                 lat = rep(lat, each = nlon),
                 time = rep(time, nlon * nlat),
                 value = as.vector(variable_data)) %>%
    filter(time == 0)

# Convert time values to actual dates
start_date <- as.Date("1800-01-01") # Specify the start date of the data
df$time <- start_date + df$time - 1
df1 = df %>% filter
# Close the NetCDF file
nc_close(nc_data)

# Plot the variable data using ggplot2
ggplot(df, aes(lon, lat, fill = value)) +
    geom_raster() +
    scale_fill_viridis() +
    labs(title = "Global Temperature") +
    theme_minimal()
