library(data.table)
library(ggplot2)
library(mapview)
library(sf)


runoff_eu_day <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('~/R/Projects/eda_eu_rivers-master/data/runoff_eu_year.rds')


runoff_eu_info[, sname := factor(abbreviate(Station))]
runoff_eu_info[, id := factor(ID)]
runoff_eu_info[, lat := round(Lat, 3)]
runoff_eu_info[, lon := round(Lon, 3)]
runoff_eu_info[, alt := round(Alt, 0)]

runoff_station_day <- merge(runoff_eu_info, runoff_eu_day, by = "id")



cz_runoff_day <- runoff_station_day[Country == "CZ"]
ru_runoff_day <- runoff_station_day[Country == "RU"]
de_runoff_day <- runoff_station_day[Country == "DE"]
no_runoff_day <- runoff_station_day[Country == "NO"]
fr_runoff_day <- runoff_station_day[Country == "FR"]
se_runoff_day <- runoff_station_day[Country == "SE"]


stations_coords_sf_cz <- st_as_sf(cz_runoff_day,
                                  coords = c('Lon', 'Lat'))
stations_coords_sf_ru <- st_as_sf(ru_runoff_day,
                                  coords = c('Lon', 'Lat'))
stations_coords_sf_de <- st_as_sf(de_runoff_day,
                                  coords = c('Lon', 'Lat'))
stations_coords_sf_no <- st_as_sf(no_runoff_day,
                                  coords = c('Lon', 'Lat'))
stations_coords_sf_fr <- st_as_sf(fr_runoff_day,
                                  coords = c('Lon', 'Lat'))
stations_coords_sf_se <- st_as_sf(se_runoff_day,
                                  coords = c('Lon', 'Lat'))

mapview(stations_coords_sf_cz, map.types = 'Stamen.TerrainBackground')
mapview(stations_coords_sf_ru, map.types = 'Stamen.TerrainBackground')
mapview(stations_coords_sf_de, map.types = 'Stamen.TerrainBackground')
mapview(stations_coords_sf_no, map.types = 'Stamen.TerrainBackground')
mapview(stations_coords_sf_fr, map.types = 'Stamen.TerrainBackground')
mapview(stations_coords_sf_se, map.types = 'Stamen.TerrainBackground')

saveRDS(cz_runoff_day, '~/R/Projects/eda_eu_rivers-master/data/cz_runoff.rds')
saveRDS(de_runoff_day, '~/R/Projects/eda_eu_rivers-master/data/de_runoff.rds')
saveRDS(fr_runoff_day, '~/R/Projects/eda_eu_rivers-master/data/fr_runoff.rds')
saveRDS(no_runoff_day, '~/R/Projects/eda_eu_rivers-master/data/no_runoff.rds')
saveRDS(ru_runoff_day, '~/R/Projects/eda_eu_rivers-master/data/ru_runoff.rds')
saveRDS(se_runoff_day, '~/R/Projects/eda_eu_rivers-master/data/se_runoff.rds')
saveRDS(stations_coords_sf_cz, '~/R/Projects/eda_eu_rivers-master/data/cz_cord.rds')
saveRDS(stations_coords_sf_de, '~/R/Projects/eda_eu_rivers-master/data/de_cord.rds')
saveRDS(stations_coords_sf_fr, '~/R/Projects/eda_eu_rivers-master/data/fr_cord.rds')
saveRDS(stations_coords_sf_no, '~/R/Projects/eda_eu_rivers-master/data/no_cord.rds')
saveRDS(stations_coords_sf_ru, '~/R/Projects/eda_eu_rivers-master/data/ru_cord.rds')
saveRDS(stations_coords_sf_se, '~/R/Projects/eda_eu_rivers-master/data/se_cord.rds')
saveRDS(runoff_station_day, '~/R/Projects/eda_eu_rivers-master/data/runoff_station_raw.rds')




