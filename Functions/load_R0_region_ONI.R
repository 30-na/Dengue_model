library(dplyr)


load("processedData/grid_country_clean.rda")
load("processedData/temp_cpc.rda")


caribbean_countries <- c(
    "Antigua and Barbuda", "Bahamas", "Barbados", "Belize", "Cuba", 
    "Dominica", "Dominican Republic", "Grenada", "Guyana", "Haiti", 
    "Jamaica", "Saint Kitts and Nevis", "Saint Lucia", 
    "Saint Vincent and the Grenadines", "Suriname", "Trinidad and Tobago", 
    "Anguilla", "Aruba", "British Virgin Islands", "Cayman Islands", 
    "Curaçao", "Montserrat", "Puerto Rico", "Saint Barthélemy", 
    "Saint Martin", "Sint Maarten", "Turks and Caicos Islands", 
    "U.S. Virgin Islands"
    )

central_america <- c(
    "Belize", "Costa Rica", "El Salvador", "Guatemala", 
    "Honduras", "Nicaragua", "Panama", "Mexico"
)

south_america <- c(
    "Argentina", "Bolivia", "Brazil", "Chile", 
    "Colombia", "Ecuador", "Guyana", "Paraguay", 
    "Peru", "Suriname", "Uruguay", "Venezuela"
)

sub_saharan_africa <- c(
    "Angola", "Benin", "Botswana", "Burkina Faso", "Burundi", 
    "Cameroon", "Cape Verde", "Central African Rep.", "Chad", "Comoros", 
    "Congo", "Côte d'Ivoire", 
    "Djibouti", "Eq. Guinea", "Eritrea", "Ethiopia", "Gabon", 
    "Gambia", "Ghana", "Guinea", "Guinea-Bissau", "Kenya", "Lesotho", 
    "Liberia", "Madagascar", "Malawi", "Mali", "Mauritania", "Mauritius", 
    "Mozambique", "Namibia", "Niger", "Nigeria", "Réunion", "Rwanda", 
    "Sao Tome and Principe", "Senegal", "Seychelles", "Sierra Leone", 
    "Somalia", "South Africa", "Sudan", "eSwatini", "Tanzania", "Togo", 
    "Uganda", "W. Sahara", "Zambia", "Zimbabwe"
)

south_east_asia <- c(
    "Brunei", "Myanmar", "Cambodia", "Timor-Leste", "Indonesia", 
    "Laos", "Malaysia", "Philippines", "Singapore", "Thailand", "Vietnam"
)


south_asia <- c(
    "Afghanistan", "Bangladesh", "Bhutan", "India", "Iran", 
    "Maldives", "Nepal", "Pakistan", "Sri Lanka"
)


oceania <- c(
    "Australia", "Federated States of Micronesia", "Fiji", 
    "Kiribati", "Marshall Islands", "Nauru", "New Zealand", 
    "Palau", "Papua", "Samoa", "Solomon Is.", 
    "Kingdom of Tonga", "Tuvalu", "Vanuatu", "Cook Islands", 
    "Niue", "American Samoa", "French Polynesia", "Guam", 
    "Hawaii", "New Caledonia", "Mariana Islands"
)


## 01

load("processedData/r01.rda")

r01C <- merge(r01, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
        ),
        Year = format(Date, "%Y"),
        Month = format(Date, "%B"),
        Month = factor(Month,
                       levels = c("January", "February", "March", "April", "May", "June",
                                  "July", "August", "September", "October", "November", "December"))
        ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
        )

save(r01C, file = "ProcessedData/r01C.rda")


## 02

load("processedData/r02.rda")

r02C <- merge(r02, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r02C, file = "ProcessedData/r02C.rda")



## 03

load("processedData/r03.rda")

r03C <- merge(r03, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r03C, file = "ProcessedData/r03C.rda")



## 04

load("processedData/r04.rda")

r04C <- merge(r04, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r04C, file = "ProcessedData/r04C.rda")



## 05

load("processedData/r05.rda")

r05C <- merge(r05, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r05C, file = "ProcessedData/r05C.rda")



## 06

load("processedData/r06.rda")

r06C <- merge(r06, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r06C, file = "ProcessedData/r06C.rda")


## 07

load("processedData/r07.rda")

r07C <- merge(r07, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r07C, file = "ProcessedData/r07C.rda")



## 01

load("processedData/r08.rda")

r08C <- merge(r08, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r08C, file = "ProcessedData/r08C.rda")


## 09

load("processedData/r09.rda")

r09C <- merge(r09, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r09C, file = "ProcessedData/r09C.rda")


## 10

load("processedData/r10.rda")

r10C <- merge(r10, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r10C, file = "ProcessedData/r10C.rda")


## 01

load("processedData/r11.rda")

r11C <- merge(r11, grid_country_clean, by=c("Longitude", "Latitude")) %>%
    mutate(regions = case_when(
        country %in% oceania ~ "oceania",
        country %in% south_asia ~ "south_asia",
        country %in% south_east_asia ~ "south_east_asia",
        country %in% sub_saharan_africa ~ "sub_saharan_africa",
        country %in% south_america ~ "south_america",
        country %in% central_america ~ "central_america",
        country %in% caribbean_countries ~ "caribbean_countries"
    ),
    Year = format(Date, "%Y"),
    Month = format(Date, "%B"),
    Month = factor(Month,
                   levels = c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"))
    ) %>%
    dplyr::select(
        Year,
        Month,
        regions,
        country,
        r0_briere,
        r0_quadratic
    )

save(r11C, file = "ProcessedData/r11C.rda")


library(dplyr)

# List of .rda files
rda_files <- paste0("processedData/r", sprintf("%02d", 1:11), "C.rda")


for(i in 1:5){
    load(rda_files[i])
}

R0Region1 <- rbind(
    r01C,
    r02C,
    r03C,
    r04C,
    r05C
) %>%
    dplyr::filter(
        Year < "1978"
    ) %>%
    group_by(Year,
             Month,
             regions) %>%
    summarize(
        mean_r0_briere = mean(r0_briere, na.rm = TRUE),
        mean_r0_quad = mean(r0_quadratic, na.rm = TRUE)
    )

save(R0Region1, file = "processedData/R0Region1.rda")





for(i in 5:8){
    load(rda_files[i])
}

R0Region2 <- rbind(
    r05C,
    r06C,
    r07C,
    r08C
) %>%
    dplyr::filter(
        Year >= "1978" & Year < "1999"
    ) %>%
    group_by(Year,
             Month,
             regions) %>%
    summarize(
        mean_r0_briere = mean(r0_briere, na.rm = TRUE),
        mean_r0_quad = mean(r0_quadratic, na.rm = TRUE)
    )

save(R0Region2, file = "processedData/R0Region2.rda")




for(i in 8:11){
    load(rda_files[i])
}

R0Region3 <- rbind(
    r08C,
    r09C,
    r10C,
    r11C
) %>%
    dplyr::filter(
        Year >= "1999"
    ) %>%
    group_by(Year,
             Month,
             regions) %>%
    summarize(
        mean_r0_briere = mean(r0_briere, na.rm = TRUE),
        mean_r0_quad = mean(r0_quadratic, na.rm = TRUE)
    )

save(R0Region3, file = "processedData/R0Region3.rda")



load("processedData/R0Region1.rda")
load("processedData/R0Region2.rda")
load("processedData/R0Region3.rda")

R0Region <- rbind(
    R0Region1,
    R0Region2,
    R0Region3
    )

save(R0Region, file = "processedData/R0Region.rda")



###### Calculate average for months for each region

library(dplyr)

# List of .rda files
rda_files <- paste0("processedData/r", sprintf("%02d", 1:11), "C.rda")


for(i in 1:5){
    load(rda_files[i])
}

R0Region1M <- rbind(
    r01C,
    r02C,
    r03C,
    r04C,
    r05C
) %>%
    dplyr::filter(
        Year < "1978"
    ) %>%
    dplyr::select(
        Month,
        regions,
        r0_briere,
        r0_quadratic
    )

save(R0Region1M, file = "processedData/R0Region1M.rda")





for(i in 5:8){
    load(rda_files[i])
}

R0Region2M <- rbind(
    r05C,
    r06C,
    r07C,
    r08C
    ) %>%
    dplyr::filter(
        Year >= "1978" & Year < "1999"
    ) %>%
    dplyr::select(
        Month,
        regions,
        r0_briere,
        r0_quadratic
    )

save(R0Region2M, file = "processedData/R0Region2M.rda")



for(i in 8:11){
    load(rda_files[i])
}

R0Region3M <- rbind(
    r08C,
    r09C,
    r10C,
    r11C
    ) %>%
    dplyr::filter(
        Year >= "1999"
    )  %>%
    dplyr::select(
        Month,
        regions,
        r0_briere,
        r0_quadratic
    )

save(R0Region3M, file = "processedData/R0Region3M.rda")



load("processedData/R0Region1M.rda")
load("processedData/R0Region2M.rda")
load("processedData/R0Region3M.rda")


## caribbean_countries
caribbean_countries1 <- dplyr::filter(R0Region1M, regions == "caribbean_countries")
caribbean_countries2 <- dplyr::filter(R0Region2M, regions == "caribbean_countries")
caribbean_countries3 <- dplyr::filter(R0Region3M, regions == "caribbean_countries")
caribbean_countries_df <- rbind(
    caribbean_countries1,
    caribbean_countries2,
    caribbean_countries3
) %>%
    group_by(Month) %>%
    summarize(
        mean_ber_total = mean(r0_briere, na.rm = TRUE),
        mean_quad_total = mean(r0_quadratic, na.rm = TRUE)
    ) %>%
    dplyr::mutate(
        regions = "caribbean_countries"
    )

## central_america
central_america1 <- dplyr::filter(R0Region1M, regions == "central_america")
central_america2 <- dplyr::filter(R0Region2M, regions == "central_america")
central_america3 <- dplyr::filter(R0Region3M, regions == "central_america")
central_america_df <- rbind(
    central_america1,
    central_america2,
    central_america3
) %>%
    group_by(Month) %>%
    summarize(
        mean_ber_total = mean(r0_briere, na.rm = TRUE),
        mean_quad_total = mean(r0_quadratic, na.rm = TRUE)
    ) %>%
    dplyr::mutate(
        regions = "central_america"
    )


## south_america
south_america1 <- dplyr::filter(R0Region1M, regions == "south_america")
south_america2 <- dplyr::filter(R0Region2M, regions == "south_america")
south_america3 <- dplyr::filter(R0Region3M, regions == "south_america")
south_america_df <- rbind(
    south_america1,
    south_america2,
    south_america3
) %>%
    group_by(Month) %>%
    summarize(
        mean_ber_total = mean(r0_briere, na.rm = TRUE),
        mean_quad_total = mean(r0_quadratic, na.rm = TRUE)
    ) %>%
    dplyr::mutate(
        regions = "south_america"
    )


## sub_saharan_africa
sub_saharan_africa1 <- dplyr::filter(R0Region1M, regions == "sub_saharan_africa")
sub_saharan_africa2 <- dplyr::filter(R0Region2M, regions == "sub_saharan_africa")
sub_saharan_africa3 <- dplyr::filter(R0Region3M, regions == "sub_saharan_africa")
sub_saharan_africa_df <- rbind(
    sub_saharan_africa1,
    sub_saharan_africa2,
    sub_saharan_africa3
) %>%
    group_by(Month) %>%
    summarize(
        mean_ber_total = mean(r0_briere, na.rm = TRUE),
        mean_quad_total = mean(r0_quadratic, na.rm = TRUE)
    ) %>%
    dplyr::mutate(
        regions = "sub_saharan_africa"
    )




## south_east_asia
south_east_asia1 <- dplyr::filter(R0Region1M, regions == "south_east_asia")
south_east_asia2 <- dplyr::filter(R0Region2M, regions == "south_east_asia")
south_east_asia3 <- dplyr::filter(R0Region3M, regions == "south_east_asia")
south_east_asia_df <- rbind(
    south_east_asia1,
    south_east_asia2,
    south_east_asia3
) %>%
    group_by(Month) %>%
    summarize(
        mean_ber_total = mean(r0_briere, na.rm = TRUE),
        mean_quad_total = mean(r0_quadratic, na.rm = TRUE)
    ) %>%
    dplyr::mutate(
        regions = "south_east_asia"
    )


## south_asia
south_asia1 <- dplyr::filter(R0Region1M, regions == "south_asia")
south_asia2 <- dplyr::filter(R0Region2M, regions == "south_asia")
south_asia3 <- dplyr::filter(R0Region3M, regions == "south_asia")
south_asia_df <- rbind(
    south_asia1,
    south_asia2,
    south_asia3
) %>%
    group_by(Month) %>%
    summarize(
        mean_ber_total = mean(r0_briere, na.rm = TRUE),
        mean_quad_total = mean(r0_quadratic, na.rm = TRUE)
    ) %>%
    dplyr::mutate(
        regions = "south_asia"
    )


## oceania
oceania1 <- dplyr::filter(R0Region1M, regions == "oceania")
oceania2 <- dplyr::filter(R0Region2M, regions == "oceania")
oceania3 <- dplyr::filter(R0Region3M, regions == "oceania")
oceania_df <- rbind(
    oceania1,
    oceania2,
    oceania3
) %>%
    group_by(Month) %>%
    summarize(
        mean_ber_total = mean(r0_briere, na.rm = TRUE),
        mean_quad_total = mean(r0_quadratic, na.rm = TRUE)
    ) %>%
    dplyr::mutate(
        regions = "oceania"
    )




R0MeanMonthStatRegions <- rbind(
    caribbean_countries_df,
    central_america_df,
    south_america_df,
    sub_saharan_africa_df,
    south_east_asia_df,
    south_asia_df,
    oceania_df
)

save(R0MeanMonthStatRegions, file = "processedData/R0MeanMonthStatRegions.rda")



