library(tidyr)
library(ggplot2)
library(data.table)
runoff_eu_day <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_year.rds')

runoff_eu_day <- runoff_eu_day[value >= 0]
runoff_eu_day$month <- format(as.Date(runoff_eu_day$date), "%m")
runoff_eu_day$year <- format(as.Date(runoff_eu_day$date), "%Y")
### Descriptive statistics(uncliding mean high/low ratios of runoff)


runoff_characteristic <- runoff_eu_day[, .(mean(value), max(value), min(value), sd(value), median(value)), by = .(id,year)]
colnames(runoff_characteristic) <-  c("id","year","mean","max","min","sd","median")
runoff_characteristic
runoff_characteristic$COV <- runoff_characteristic$sd/runoff_characteristic$mean
runoff_characteristic$skew <- 3*(runoff_characteristic$mean - runoff_characteristic$median)/runoff_characteristic$sd
runoff_characteristic$mean_max_ratio <- runoff_characteristic$mean/runoff_characteristic$max
runoff_characteristic$mean_min_ratio <- runoff_characteristic$mean/runoff_characteristic$min
runoff_characteristic
runoff_characteristic$range <- runoff_characteristic$max - runoff_characteristic$min


### Categories for the stations



