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


runoff_characteristic[year >= 1980, year_class := factor('Post 1980')]
runoff_characteristic[year < 1980, year_class := factor('Pre 1980')]
change_in_ratio <- runoff_characteristic[, .(mean(mean_max_ratio), mean(mean_min_ratio)), by = .(id, year_class)]
unique(change_in_ratio[,1])
change_in_ratio[, year_class]
change_in_ratio <- change_in_ratio[-1,]
change_in_ratio$id
change_in_ratio[237]
change_in_ratio <- change_in_ratio[-237,]
## Creating a loop to see change in ratio
## Estimate and present the change in the ratios of mean/high 
## and mean/low runoff ratios for before and after 1980 for each 
## station separately and for the categories.
meanmax_difference <- c()

for (i in 1:length(rownames(change_in_ratio))) {
  meanmax_difference[i] <- change_in_ratio$V1[(2 * i)] - change_in_ratio$V1[((2 * i)-1)]
}
meanmax_difference <- meanmax_difference[1:200]
meanmin_difference <- c()
for (i in 1:length(rownames(change_in_ratio))) {
  meanmin_difference[i] <- change_in_ratio$V1[(2 * i)] - change_in_ratio$V1[((2 * i)-1)]
}
meanmin_difference <- meanmin_difference[1:200]
meanmin_difference
print(change_in_ratio[,1], topn = 400)
change_in_ratio
print(unique(change_in_ratio[,1]), topn = 201)

ratio_difference <- data.table(meanmax_difference, meanmin_difference, unique(change_in_ratio[,1]))
str(ratio_difference)
colnames(ratio_difference) <- c("meanmax_difference", "meanmin_difference", "ID")



characteristic_2[120,]
characteristic_2 <- characteristic_2[-c(1,120),]
characteristic_2

ratio_difference$ID <- as.numeric(ratio_difference$ID)
ratio_difference_2 <- merge(characteristic_2,ratio_difference)
ratio_difference_2 <- ratio_difference_2[,c(1,5,6,7,8,9)]
ratio_difference_2[, mean(meanmax_difference), by = max_range_class]
ratio_difference_2[, mean(meanmax_difference), by = min_range_class][1:3,]
ratio_difference_2[, mean(meanmax_difference), by = alt_range_class][c(1,3,4),]
ratio_difference_2[, mean(meanmin_difference), by = max_range_class]
ratio_difference_2[, mean(meanmax_difference), by = min_range_class][1:3]
ratio_difference_2[, mean(meanmax_difference), by = alt_range_class][c(1,3,4),]
## Aggregate daily to winter/summer runoff.

runoff_eu_day$month <- as.numeric(runoff_eu_day$month)
runoff_eu_day[(month < 4), season := factor('winter')]
runoff_eu_day[(month > 6) & (month < 10), season := factor('summer')]
runoff_eu_day[300:350,]
summer_winter_runnoff <- runoff_eu_day[,mean(value), by = .(id,season)]
winter <- which(summer_winter_runnoff$season == "winter")
summer <- which(summer_winter_runnoff$season == "summer")
summer_winter_runnoff[c(winter, summer),]
runoff_eu_day$year <- as.numeric(runoff_eu_day$year)
runoff_eu_day[year >= 1980, year_class := factor('Post 1980')]
runoff_eu_day[year < 1980, year_class := factor('Pre 1980')]
runoff_eu_day
summer_winter <- runoff_eu_day[,mean(value), by = .(id,season,year_class)]
winter_2 <- which(summer_winter$season == "winter")
summer_2 <- which(summer_winter$season == "summer")
summer_winter <- summer_winter[c(winter_2, summer_2),]
summer_winter
unique(summer_winter$id)
summer_winter$year_class
summer_winter <- summer_winter[-1,]
summer_winter <- summer_winter[-237,]
summer_winter <- summer_winter[-401,]
summer_winter <- summer_winter[-637,]
summer_winter
percentage_change <- c()
for (i in 1:length(rownames(summer_winter))) {
  percentage_change[i] <- 100*(summer_winter$V1[(2 * i)] - summer_winter$V1[((2 * i)-1)])/(summer_winter$V1[((2 * i)-1)])
}
winter <- percentage_change[1:200]
summer <- percentage_change[201:400]
percentage_of_change <- data.table(unique(summer_winter[,1]), winter, summer)
percentage_of_change

## Estimate and present the percentage of change in winter/summer 
## runoff for before and after 1980. Then create a map showing 
## positive and negative change in winter/summer runoff after 1980.

percentage_of_change$ID_type_winter <- ifelse(winter < 0, "below", "above")
ggplot(percentage_of_change, aes(x=id, y=winter, label=winter)) + 
  geom_bar(stat='identity', aes(fill=ID_type_winter), width=.5)  +
  scale_fill_manual(name="Percentage change of winter runoff", 
                    labels = c("Positive(+)", "Negitive(-)"), 
                    values = c("above"="#FF0000", "below"="#0027FF")) + 
  labs(subtitle="Percentage change of runnoff at stations before and after 1980", 
       title= "Plot of winter runoff") + 
  coord_flip()

coord_flip()
percentage_of_change$ID_type_summer <- ifelse(summer < 0, "below", "above")
ggplot(percentage_of_change, aes(x=id, y=summer, label=summer)) + 
  geom_bar(stat='identity', aes(fill=ID_type_summer), width=.5)  +
  scale_fill_manual(name="Percentage change of summer runoff", 
                    labels = c("Positive(+)", "Negitive(-)"), 
                    values = c("above"="#FF0000", "below"="#0027FF")) + 
  labs(subtitle="Percentage change of mean runnoff at stations before and after 1980", 
       title= "Plot of summer runoff") + 
  coord_flip()






