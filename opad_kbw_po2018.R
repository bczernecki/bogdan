library(raster)
setwd("~/opad")



library(raster)
pliki = dir(pattern='201[8-9]')


library(rgdal)
pol <- readOGR("~/github/susza_serie/data/gis/POL_adm0.shp")
r = raster(pliki[1])
crs = crs(r)
pol <- spTransform(pol, crs)
plot(r)
plot(pol, add=T)


wynik = NULL
for (i in 1:length(pliki)){
  print(i)
  r = raster(pliki[i])
  tmp = mask(r, pol)
  wynik = c(wynik, mean(tmp[], na.rm=T))
  
}

plot(wynik)
opad2 = data.frame(data = seq.Date(from = as.Date("2018-01-01"), to = as.Date("2019-12-31"), by = "day"), opad = wynik)
plot(opad2)

library(dplyr)
head(opad2)

library(lubridate)

opad2 = opad2 %>% group_by(year(data), month(data)) %>% summarise(opad = sum(opad))

colnames(opad2) = c("yy", "mm", "opad")
head(opad)

opad_caly = data.frame(data = seq.Date(from = as.Date("1987-01-01"), to = as.Date("2019-12-31"), by = "month"), 
                       opad = c(opad$opad[1:372], opad2$opad))

tail(opad_caly)
saveRDS(opad_caly, "~/github/bogdan/data/opad_caly.rds")





### teraz to samo dla kbw:
library(raster)
setwd("~/KBW/")
library(raster)
pliki = dir(pattern='201[8-9]')


library(rgdal)
pol <- readOGR("~/github/susza_serie/data/gis/POL_adm0.shp")
r = raster(pliki[1])
crs = crs(r)
pol <- spTransform(pol, crs)
plot(r)
plot(pol, add=T)


wynik = NULL
for (i in 1:length(pliki)){
  print(i)
  r = raster(pliki[i])
  tmp = mask(r, pol)
  wynik = c(wynik, mean(tmp[], na.rm=T))
  
}

plot(wynik)
kbw2 = data.frame(data = seq.Date(from = as.Date("2018-11-01"), to = as.Date("2019-12-31"), by = "day"), kbw = wynik)
plot(kbw2)



library(dplyr)
head(kbw2)
library(lubridate)

kbw2 = kbw2 %>% group_by(year(data), month(data)) %>% summarise(kbw = sum(kbw))

colnames(kbw2) = c("yy", "mm", "opad")
head(kbw2)

kbw_caly = data.frame(data = seq.Date(from = as.Date("1987-01-01"), to = as.Date("2019-12-31"), by = "month"), 
                       kbw = c(kbw$kbw[1:381], 8, kbw2$opad))

tail(kbw_caly)

saveRDS(kbw_caly, "~/github/bogdan/data/kbw_caly.rds")
saveRDS(opad_caly, "~/github/bogdan/data/opad_caly.rds")
