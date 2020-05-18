library(data.table)
library(ggplot2)
getwd()
runoff_eu_day <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_year.rds')


runoff_eu_info[, sname := factor(abbreviate(Station))]
runoff_eu_info[, id := factor(ID)]
runoff_eu_info[, lat := round(Lat, 3)]
runoff_eu_info[, lon := round(Lon, 3)]
runoff_eu_info[, alt := round(Alt, 0)]


runoff_eu_day <- runoff_eu_day[value >= 0]
runoff_eu_day$month <- format(as.Date(runoff_eu_day$date), "%m")
runoff_eu_day$year <- format(as.Date(runoff_eu_day$date), "%Y")

saveRDS(runoff_eu_info, './data/runoff_info_raw.rds')
saveRDS(runoff_eu_day, './data/runoff_day_raw.rds')
saveRDS(runoff_eu_year, './data/runoff_year_raw.rds')


