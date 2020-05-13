library(tidyr)
library(ggplot2)
library(data.table)

runoff_eu_day <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_year.rds')

runoff_eu_info[, sriver := factor(abbreviate(River))]
runoff_eu_info[, sname := factor(abbreviate(Station))]
rivers_lovation <- runoff_eu_info[,list(River, Country, Continent, sriver, sname)]
rivers_lovation
river_country <- rivers_lovation[, list(Country)]


station_per_country <- rivers_lovation[, .(start = min(Country),
                                           end = max(Country)),
                                           by = sname]
taaz
