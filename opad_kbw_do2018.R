library(raster)
setwd("~/github/susza_serie/opad/")
pliki = dir(pattern='tif')


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
opad = data.frame(data = seq.Date(from = as.Date("1987-01-01"), to = as.Date("2018-09-01"), by = "month"), opad = wynik)

head(opad)
plot(opad, type='l')




setwd("~/github/susza_serie/")
pliki = dir(pattern='KBW_')
pliki = pliki[grepl(pliki, pattern="tif")]
wynik = NULL
for (i in 1:length(pliki)){
  print(i)
  r = raster(pliki[i])
  tmp = mask(r, pol)
  wynik = c(wynik, mean(tmp[], na.rm=T))
  
}


kbw = data.frame(data = seq.Date(from = as.Date("1987-01-01"), to = as.Date("2018-09-01"), by = "month"), kbw = wynik)
head(kbw)
dir.create("~/github/bogdan/data")
saveRDS(kbw, "~/github/bogdan/data/kbw.rds")
saveRDS(opad, "~/github/bogdan/data/opad.rds")
