# Install and load necessary packages
#install.packages("rvest")
library(rvest)
library(dplyr)
# Define the URL of the webpage
url <- "https://origin.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_v5.php"

# Read the HTML content of the webpage
webpage <- read_html(url)

# Extract the table from the webpage
table_data <- html_table(webpage)

# Extract the table of temp and clean the data
temp_cpc_raw <- table_data[[9]]
names(temp_cpc_raw) <- temp_cpc_raw[1,]
temp_cpc <- temp_cpc_raw %>%
    dplyr::filter(
        Year != "Year",
        Year <= 2023
    )


# save file as RDA
save(temp_cpc,
     file = "processedData/temp_cpc.rda")
