# load library
library(dplyr)


# load the data
load("processedData/r01.rda")

r11 <- R0_data[200000001:220838400,c(3,4,5,8,9)]

save(r11,
     file = "processedData/r11.rda")


