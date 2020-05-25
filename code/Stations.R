library(data.table)
library(mapview)
library(sf)
library(plyr)

runoff_eu_day <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_year.rds')

## Q1: where are the stations located?

stations_coords <- st_as_sf(runoff_eu_info,
                            coords = c('Lon', 'Lat'),
                            crs = 4326)

mapview(stations_coords, map.types = 'Stamen.TerrainBackground')

## bigger part of all stations are located in central europe, a lot of stations are in Scandinavia



## Q2: How many stations/rivers per country


station_per_country <- runoff_eu_info[, .(Station), by = Country]
stations_country <- as.data.frame(table(station_per_country))


stations_country_table <- ddply(stations_country, "Country", numcolwise(sum))
stations_country_table
##in France located bigger part of all europian stations (78), then goes Sweden(27) and Norway(26)
## Q3: How many stations exist per river?
rivers_per_country <- runoff_eu_info[, list(River, Country)]
rivers_per_country <- rivers_per_country[!duplicated(rivers_per_country$River)]
rivers_per_country <- rivers_per_country[, .N, by = Country]
stations_per_river <- runoff_eu_info[, list(Station, River)]
stations_per_river <- stations_per_river[, .N, by = River]
## Q4: Which is the distribution of stations in space (latitude, longitude and altitude)?
distribution <- runoff_eu_info[, list(Station, Lat, Lon, Alt)]#distribution of station 
distribution[, Lat := round(Lat, 3)]#just some rounding to have better values
distribution[, Lon := round(Lon, 3)]
distribution[, Alt := round(Alt, 0)]
## Q5: Which is the distribution of record length?
year <- runoff_eu_info[, list(Station, N.Years)]#record length

space <- ggplot(data = distribution, aes(x = Lat, y = Lon, size = Alt)) +
  geom_point()
space # Plotting lon and lat of station with different alt

year_plot <- ggplot(data = year, aes(x = 1:208, y = N.Years)) +
  geom_point()
year_plot #the bigger part of stations have 100 year of data



saveRDS(rivers_lovation, '~/eda_eu_rivers/assigment/rivers_lovation.rds')
saveRDS(station_per_country, '~/eda_eu_rivers/assigment/station_per_country.rds')
saveRDS(rivers_per_country, '~/eda_eu_rivers/assigment/rivers_per_country.rds')
saveRDS(stations_per_river, '~/eda_eu_rivers/assigment/stations_per_river.rds')
saveRDS(distribution, '~/eda_eu_rivers/assigment/distribution.rds')
saveRDS(year, '~/eda_eu_rivers/assigment/year.rds')