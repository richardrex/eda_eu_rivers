library(tidyr)
library(ggplot2)
library(data.table)
runoff_eu_day <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_year.rds')

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

characteristic_1 <- runoff_characteristic[, .(max(range), min(range)), by = id]
colnames(characteristic_1) <- c("ID","max_range", "min_range")
characteristic_1$ID <- as.numeric(characteristic_1$ID)
###Here will merge two tables runoff_info and new characteristic table
characteristic_2 <- merge(characteristic_1, runoff_eu_info)
characteristic_2 <- characteristic_2[,c(1,2,3,10)]
characteristic_2


ggplot(characteristic_2, aes(x=1:202, y = max_range)) +
  geom_point()
### As we can range can be splitted as 0:2500 as low , 2500:5000 as medium (because most of dots are between this range)
### And 5000: as high 
ggplot(characteristic_2, aes(x=1:202, y = min_range)) +
  geom_point()
###Here low will be 0:500 medium 500:1000 and high after 1000
ggplot(characteristic_2, aes(x=1:202, y = Alt)) +
  geom_point()
###Low from 0 to 300 medium 300:600 and high upper 600

characteristic_2[max_range < 2500, max_range_class := factor('low')]
characteristic_2[max_range > 2500 & max_range < 5000, max_range_class := factor('medium')]
characteristic_2[max_range > 5000, max_range_class := factor('high')]
characteristic_2[min_range < 500, min_range_class := factor('low')]
characteristic_2[min_range > 500 & min_range < 1000, min_range_class := factor('medium')]
characteristic_2[min_range > 1000, min_range_class := factor('high')]
characteristic_2[Alt < 200, alt_range_class := factor('low')]
characteristic_2[Alt > 200 & Alt < 600, alt_range_class := factor('medium')]
characteristic_2[Alt > 600, alt_range_class := factor('high')]
characteristic_2


saveRDS(characteristic_1, '~/R/Projects/eda_eu_rivers-master/data/characteristic_1.rds')
saveRDS(characteristic_2, '~/R/Projects/eda_eu_rivers-master/data/characteristic_2.rds')
saveRDS(runoff_characteristic, '~/R/Projects/eda_eu_rivers-master/data/runoff_char.rds')









