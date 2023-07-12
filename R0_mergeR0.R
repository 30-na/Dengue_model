# Load and merge R0 data
load("processedData/R0_data1.rda")
load("processedData/R0_data2.rda")
load("processedData/R0_data3.rda")


#merged data
R0_data = rbind(
    R0_data1,
    R0_data2,
    R0_data3
)

# save the result
save(R0_data, file = "processedData/R0_data.rda")