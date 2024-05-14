# Install and load necessary packages
#install.packages("rvest")
library(rvest)
library(dplyr)
library(reshape2)
library(purrr)
library(zoo)

# Define the URL of the webpage
url <- "https://origin.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_v5.php"

# Read the HTML content of the webpage
webpage <- read_html(url)

# Extract the table from the webpage
table_data <- html_table(webpage)

# Extract the table of temp and clean the data
temp_cpc_raw <- table_data[[9]]
names(temp_cpc_raw) <- temp_cpc_raw[1,]

# Define a function to check if the sum is equal to 5
check_sum_5 <- function(x) {
    sum(x) == 5
}

temp_cpc <- temp_cpc_raw %>%
    dplyr::filter(
        Year != "Year",
        Year <= 2023
    ) %>%
    reshape2::melt(
        id.vars = "Year", variable.name = "month", value.name = "ONI"
    ) %>%
    arrange(
        Year, month
    ) %>%
    mutate(
        highTemp = ifelse(ONI >= 0.5, 1, 0),
        monthb4 = lag(highTemp, 4),
        monthb3 = lag(highTemp, 3),
        monthb2 = lag(highTemp, 2),
        monthb1 = lag(highTemp, 1),
        monthn1 = lead(highTemp, 1),
        monthn2 = lead(highTemp, 2),
        monthn3 = lead(highTemp, 3),
        monthn4 = lead(highTemp, 4),
        Elnino = ifelse((highTemp+ monthb4+ monthb3+ monthb2+monthb1+monthn1+monthn2+monthn3+monthn4) >= 5, 1, 0)
    )

str(temp_cpc)


str(temp_cpc)
# save file as RDA
save(temp_cpc,
     file = "processedData/temp_cpc.rda")
