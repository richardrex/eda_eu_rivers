library(ggplot2)
library(data.table)

runoff_info <- readRDS('./data/runoff_info_raw.rds')
runoff_day <- readRDS('./data/runoff_day_raw.rds')
runoff_year <- readRDS('./data/runoff_year_raw.rds')


runoff_station_day <- merge(runoff_info, runoff_day, by = "id")
runoff_station_day


runoff_station_year <- merge(runoff_info, runoff_year, by = "ID")
runoff_station_year
### Lets find missing data 
missing_value <- runoff_station_day[value < 0, .(missing = .N), by = Country]
### Create new column called missing values
sample_size <- runoff_station_day[, .(size = .N), by = sname]
runoff_station_day <- runoff_station_day[sample_size, on = 'sname']
runoff_station_day[is.na(missing), missing := 0]
runoff_station_day[, missing := missing /size]
runoff_station_day[, missing := round(missing, 3)]
setcolorder(runoff_station_day,
            c(setdiff(names(runoff_station_day), 'missing'), 'missing'))

###Lets delete all values < 0
runoff_station_day <- runoff_station_day[value >= 0]


