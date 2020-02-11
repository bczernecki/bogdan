library(readxl)
pkb = read_xlsx("data/data Poland PKB.xlsx")
head(pkb)
pkb$yy = as.numeric(sapply(pkb$Date, function(x) strsplit(x, " ")[[1]])[1,])
pkb$mm = as.numeric(sapply(pkb$Date, function(x) strsplit(x, " ")[[1]])[2,])
head(pkb )       

library(tidyverse)
pkb = select(pkb, -Date) 
head(pkb)
colnames(pkb) = c("gdp", "yy", "mm")
pkb = select(pkb, "yy", "mm", "gdp")
saveRDS(pkb, "data/pkb.rds")
pkb = readRDS("data/pkb.rds")

library(fpp)
pkb2 = ts(c(pkb$gdp/1000, 620), frequency = 4, start = c(1993,1), end = c(2019,4))

library(forecast)
trend_beer = ma(pkb2, order = 4, centre = T)
detrend_beer = pkb2 - trend_beer
plot(detrend_beer)
plot(as.ts(trend_beer))
ts_beer = pkb2
decompose_beer = decompose(ts_beer, "additive")

plot(as.ts(decompose_beer$seasonal))
plot(as.ts(decompose_beer$trend))
plot(as.ts(decompose_beer$random))
plot(decompose_beer)

#remotes::install_github("statisticspoland/R_Package_to_API_BDL", upgrade = "always", type = "binary")

decompose_beer$random

# chyba lepiej walnąć jakiś model regresyjny
head(pkb)
model = lm(gdp~yy+as.factor(mm), data=pkb)

sekwencja = seq.Date(as.Date("1993-01-01"), as.Date("2019-12-31"), by = "quarter")

plot(sekwencja, c(pkb$gdp,600000), type= 'l')
lines(sekwencja, c(predict(model), 600000), col='red')

# generalnie rośnie nam niesamowicie odchylenie standardowe w kolejnych latach 
# zatem:
head(pkb)
test = filter(pkb, mm == 1)
plot(test$gdp/sd(test$gdp))
head(pkb)

plot(pkb$gdp/sd(pkb$gdp), type='l')

pkb$sd = pkb$gdp/sd(pkb$gdp)

pkb %>% group_by(mm) %>% summarise(gdp/sd(gdp))
  
q1 = filter(pkb, mm == 3) %>% select(sd) %>% unlist()
plot(q1)
dane = data.frame(data = 1993:2019, q1 = q1)
plot(dane)
model1 = lm(q1 ~ data, dane)
abline(model1)

