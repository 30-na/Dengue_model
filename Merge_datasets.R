library("dplyr")


load("processedData/CEDA_temp_data.rda")
load("processedData/CEDA_precip_data.rda")
load("processedData/RiskOfExposure.rda")


#merge all data sets
R0_Data = temp_data %>%
    left_join(precip_data, by = c("Longitude", "Latitude","Date")) %>%
    left_join(Rse, by = c("Longitude", "Latitude"))
