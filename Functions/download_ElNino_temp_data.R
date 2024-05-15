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
        Year != "Year"
       # Year <= 2023
    ) %>%
    reshape2::melt(
        id.vars = "Year", variable.name = "month", value.name = "ONI"
    ) %>%
    arrange(
        Year, month
    ) %>%
    mutate(
        ONI = as.numeric(ONI),
        warm = ifelse(
            ONI >= 0.5, 1, 0),
        Wb4 = lag(warm, 4),
        Wb3 = lag(warm, 3),
        Wb2 = lag(warm, 2),
        Wb1 = lag(warm, 1),
        Wn1 = lead(warm, 1),
        Wn2 = lead(warm, 2),
        Wn3 = lead(warm, 3),
        Wn4 = lead(warm, 4),
        climate = ifelse(
                ((Wb4 + Wb3 + Wb2 + Wb1 + warm) >= 5 |
                 (Wb3 + Wb2 + Wb1 + warm + Wn1) >= 5 |
                 (Wb2 + Wb1 + warm + Wn1 + Wn2) >= 5 | 
                 (Wb1 + warm + Wn1 + Wn2 + Wn3) >= 5 |
                 (warm + Wn1 + Wn2 + Wn3 + Wn4) >= 5 ), "Elnino", 0),
        cold = ifelse(
            ONI <= (-0.5), 1, 0),
        Cb4 = lag(cold, 4),
        Cb3 = lag(cold, 3),
        Cb2 = lag(cold, 2),
        Cb1 = lag(cold, 1),
        Cn1 = lead(cold, 1),
        Cn2 = lead(cold, 2),
        Cn3 = lead(cold, 3),
        Cn4 = lead(cold, 4),
        climate = ifelse(
                ((Cb4 + Cb3 + Cb2 + Cb1 + cold) >= 5 |
                 (Cb3 + Cb2 + Cb1 + cold + Cn1) >= 5 |
                 (Cb2 + Cb1 + cold + Cn1 + Cn2) >= 5 | 
                 (Cb1 + cold + Cn1 + Cn2 + Cn3) >= 5 |
                 (cold + Cn1 + Cn2 + Cn3 + Cn4) >= 5), "Elnina", climate),
        temp = case_when(cold == 1 ~ "cold",
                         warm == 1 ~ "warm")
    ) %>%
    dplyr::select(
        Year,
        month,
        ONI,
        #warm,
        #cold,
        climate,
        temp
    )

# save file as RDA
save(temp_cpc,
     file = "processedData/temp_cpc.rda")
