library(data.table)
library(tidyr)
library(ggplot2)
library(mapview)
library(sf)
library(plyr)
library(corrplot)
library(zoo)
runoff_eu_day <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_day.rds')
runoff_eu_info <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_info.rds')
runoff_eu_year <- readRDS('C:/Users/42077/Documents/eda_eu_rivers/data/runoff_eu_year.rds')
colset_4 <- c("13CEBA", "0049FF", "3AFF00", "7913CE")
plot(runoff_eu_info$ID,runoff_eu_info$Alt)
## I dicided to choose rivers at approximately equal and lower altitude(due to climate:a lot of precipitation) and with common year of observation(will be easy to compare)
## ELBE, DANUBE RIVER, 	DEE (SCOTLAND), KOKEMAENJOKI, WESER
elbe_loc <- which(runoff_eu_info$River == "ELBE RIVER")
dunabe_loc <- which(runoff_eu_info$River == "DANUBE RIVER")
dee_loc <- which(runoff_eu_info$River == "DEE (SCOTLAND)")
kokamaenjoki_loc <- which(runoff_eu_info$River == "KOKEMAENJOKI")
weser_loc <- which(runoff_eu_info$River == "WESER")
elbe_loc
dee_loc

runoff_eu_day <- runoff_eu_day[value >= 0]
runoff_eu_day$month <- format(as.Date(runoff_eu_day$date), "%m")
runoff_eu_day$year <- format(as.Date(runoff_eu_day$date), "%Y")

rivers_5_info <- runoff_eu_info[c(elbe_loc,dunabe_loc,dee_loc,kokamaenjoki_loc,weser_loc),]
main_5_info <- rivers_5_info[c(5,17,19,23,27),]
main_5_info

main_5_info$ID


position_daily_runoff <- which(runoff_eu_day$id == main_5_info$ID)
position_daily_runoff
runoff_5_rivers <- runoff_eu_day[position_daily_runoff,]
runoff_5_rivers
runoff_5_rivers$month <- format(as.Date(runoff_5_rivers$date), "%m")
runoff_5_rivers$year <- format(as.Date(runoff_5_rivers$date), "%Y")


runoff_5_rivers[,by = id]

dee_river <- which(runoff_5_rivers$id == main_5_info$ID[3])
dee_river <- runoff_5_rivers[dee_river,]
dee_river
runoff_5_rivers[]
dee_river_place <- which(dee_river$year == 1994)
dee_river_place
runoff_5_rivers <- as.data.table(runoff_5_rivers)
runoff_5_rivers[,sum(value), by = .(year, id)]
sum_year_discharge <- runoff_5_rivers[,sum(value), by = .(year, id)]
sum_year_discharge
dee_roll_mean <- sum_year_discharge[1:107, .(zoo::rollmean(V1, 5),zoo::rollmean(V1, 10), zoo::rollmean(V1, 20))]

dee_roll_mean[98:103,2] <- NA
dee_roll_mean[88:103,3] <- NA
dee_roll_mean
colnames(dee_roll_mean) <- c("value_1", "value_2", "value_3")

##boxplot to present the runoff seasonality at monthly scale.
runoff_5_rivers <- runoff_5_rivers[value >= 0]
seasonal_discharge <- runoff_5_rivers[,mean(value) ,by = .(id,month,year)]
seasonal_discharge
ggplot(seasonal_discharge, aes(x = factor(month), y = V1, group = month)) +
  geom_boxplot() +
  facet_wrap(~id, scales = 'free') +
  xlab(label = "Month") +
  ylab(label = "Runoff") +
  theme_bw()



runoff_5_rivers_2 <- runoff_5_rivers

runoff_5_rivers_2$month <- as.numeric(factor((runoff_5_rivers_2$month)))
runoff_5_rivers_2[month == 1 | month == 2 | month == 3, season := factor('winter')]
runoff_5_rivers_2[month == 7 | month == 8 | month == 9, season := factor('summer')]

## add new column with seasons , mounth 1, 2, 3 - winter , 1, 8, 9 - summer ,other will be N/A
summer_runnof <- runoff_5_rivers_2[season == "summer" ] #collect dataset only with season == summer
summer_runnof <- summer_runnof[,sum(value), by = .(year,id)]
summer_runnof
winter_runnof <- runoff_5_rivers_2[season == "winter" ]#collect dataset only with season == winter
winter_runnof
winter_runnof <- winter_runnof[,sum(value), by = .(year,id)]
winter_runnof
summer_runnof$year <- as.numeric(factor((summer_runnof$year)))
winter_runnof$year <- as.numeric(factor((winter_runnof$year)))

##ggplot for  present the slopes in winter/summer runoff per station.
ggplot(summer_runnof, aes(x = year, y = V1)) +
  geom_line(col = colset_4[3], aes(group = 1))+
  geom_point(col = colset_4[3])+
  facet_wrap(~id, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = colset_4[1]) +
  geom_smooth(method = 'loess', formula = y~x, se = 0, col = colset_4[4]) +
  scale_color_manual(values = colset_4[c(1, 2, 3, 4)]) +
  xlab(label = "Year") +
  ylab(label = "Runoff (m3/s)") +
  theme_bw()
ggplot(winter_runnof, aes(x = year, y = V1)) +
  geom_line(col = colset_4[3], aes(group = 1))+
  geom_point(col = colset_4[3])+
  facet_wrap(~id, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = colset_4[1]) +
  geom_smooth(method = 'loess', formula = y~x, se = 0, col = colset_4[4]) +
  scale_color_manual(values = colset_4[c(1, 2, 3, 4)]) +
  xlab(label = "Year") +
  ylab(label = "Runoff") +
  theme_bw()
##ggplot winter and summer slope of runoff plot for all stations 
runoff_eu_day$month <- as.numeric(factor((runoff_eu_day$month)))
runoff_eu_day[month == 1 | month == 2 | month == 3, season := factor('winter')]
runoff_eu_day[month == 7 | month == 8 | month == 9, season := factor('summer')]
all_stations_summer_runoff <- runoff_eu_day[season == "summer" ]
all_stations_winter_runoff <- runoff_eu_day[season == "winter" ]
all_stations_summer_runoff <- all_stations_summer_runoff[,sum(value), by = .(year,id)]
all_stations_summer_runoff
all_stations_winter_runoff <- all_stations_winter_runoff[,sum(value), by = .(year,id)]
all_stations_winter_runoff

ggplot(all_stations_summer_runoff, aes(x = year, y = V1)) +
  geom_line(col = colset_4[1], aes(group = 1))+
  geom_point(col = colset_4[1])+
  facet_wrap(~id, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = colset_4[4]) +
  geom_smooth(method = 'loess', formula = y~x, se = 0, col = colset_4[3]) +
  scale_color_manual(values = colset_4[c(1, 2, 3, 4)]) +
  xlab(label = "Year") +
  ylab(label = "Runoff") +
  theme_bw()

ggplot(all_stations_winter_runoff, aes(x = year, y = V1)) +
  geom_line(col = colset_4[1], aes(group = 1))+
  geom_point(col = colset_4[1])+
  facet_wrap(~id, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = colset_4[4]) +
  geom_smooth(method = 'loess', formula = y~x, se = 0, col = colset_4[3]) +
  scale_color_manual(values = colset_4[c(1, 2, 3, 4)]) +
  xlab(label = "Year") +
  ylab(label = "Runoff") +
  theme_bw()

##Two last plots working bad , because in all_station_winter/summer_runoff more than 150 rivers , so there is no enough place for all plots
#





