library(readxl)
pkb = read_xls("data/gdp.xls",sheet = 1)
head(pkb)
pkb$yy = lubridate::year(pkb$data)
pkb$mm = lubridate::month(pkb$data)
head(pkb )       

library(tidyverse)
pkb = select(pkb, -data) 
head(pkb)
colnames(pkb) = c("gdp", "yy", "mm")
pkb = select(pkb, "yy", "mm", "gdp")
saveRDS(pkb, "data/gdp.rds")
pkb = readRDS("data/gdp.rds")

library(fpp)
pkb2 = ts(pkb$gdp/1000, frequency = 4, start = c(1995,1))

library(forecast)
trend_beer = ma(pkb2, order = 4, centre = T)
detrend_beer = pkb2 - trend_beer
plot(detrend_beer)
plot(as.ts(trend_beer))
ts_beer = pkb2
decompose_beer = decompose(ts_beer, "additive")

# plot(as.ts(decompose_beer$seasonal))
# plot(as.ts(decompose_beer$trend))
# plot(as.ts(decompose_beer$random))
plot(decompose_beer)
