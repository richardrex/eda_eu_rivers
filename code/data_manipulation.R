install.packages("sp")
library(tidyr)
library(ggplot2)
library(data.table)
library(sp)
runoff_eu_day <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_year.rds')

runoff_eu_info[, sriver := factor(abbreviate(River))]
runoff_eu_info[, sname := factor(abbreviate(Station))]
rivers_lovation <- runoff_eu_info[,list(River, Station, Country, ID, Continent, sriver, sname)]#Rivers location
river_country <- rivers_lovation[, list(Country)]



station_per_country <- rivers_lovation[, .N, by = Country] #How many station exist in Country
rivers_per_country <- rivers_lovation[, list(River, Country)]
rivers_per_country <- rivers_per_country[!duplicated(rivers_per_country$River)]
rivers_per_country <- rivers_per_country[, .N, by = Country] #How many rivers exist in Country
stations_per_river <- rivers_lovation[, list(Station, River)]
stations_per_river <- stations_per_river[, .N, by = River] #how many stations exist in River

distribution <- runoff_eu_info[, list(Station, Lat, Lon, Alt)]#distribution of station 
distribution[, Lat := round(Lat, 3)]#just some rounding to have better values
distribution[, Lon := round(Lon, 3)]
distribution[, Alt := round(Alt, 0)]

year <- runoff_eu_info[, list(Station, N.Years)]#record length

space <- ggplot(data = distribution, aes(x = Lat, y = Lon, size = Alt)) +
  geom_point()
space # Plotting lon and lat of station with different alt

year_plot <- ggplot(data = year, aes(x = 1:208, y = N.Years)) +
  geom_point()
year_plot #the bigger part of stations have 100 year of data



saveRDS(rivers_lovation, 'C:/Users/42077/Documents/eda_eu_rivers/assigment/rivers_lovation.rds')
saveRDS(station_per_country, 'C:/Users/42077/Documents/eda_eu_rivers/assigment/station_per_country.rds')
saveRDS(rivers_per_country, 'C:/Users/42077/Documents/eda_eu_rivers/assigment/rivers_per_country.rds')
saveRDS(stations_per_river, 'C:/Users/42077/Documents/eda_eu_rivers/assigment/stations_per_river.rds')
saveRDS(distribution, 'C:/Users/42077/Documents/eda_eu_rivers/assigment/distribution.rds')
saveRDS(year, 'C:/Users/42077/Documents/eda_eu_rivers/assigment/year.rds')
