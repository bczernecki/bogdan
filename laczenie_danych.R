library(lubridate)
df = readRDS("data/anomalie.rds")

head(df)
lista = list(c(1:3), 4:6, 7:9, 10:12)
df$q = rep(1:4, each = 3)
head(df)
tail(df)

library(tidyverse)
meteo = df %>% group_by(yy, q) %>% summarise_all(., mean)
head(meteo)

PKB = data.frame(data = seq.Date(as.Date("1995-01-01"), as.Date("2019-07-31"), by = "quarter"),
gdp_noise = decompose_beer$random, gdp_observed = decompose_beer$x)
PKB

PKB$yy = year(PKB$data)
PKB$q = rep(1:4, length.out = length(PKB$data))
head(PKB)

head(meteo)

dane = left_join(meteo, PKB)
dane$mm = NULL
dane$data = NULL
head(dane)

plot(dane$gdp_noise, dane$temp_anom)
cor(dane$gdp_observed, dane$temp_anom, use = "pairwise.complete.obs")

q1 = filter(dane, q == 1)
round(cor(q1, use = "pairwise.complete.obs"),2)

q2 = filter(dane, q == 2)
round(cor(q2, use = "pairwise.complete.obs"),2)

q3 = filter(dane, q == 3)
round(cor(q3, use = "pairwise.complete.obs"),2)

q4 = filter(dane, q == 4)
round(cor(q4[,-1:-2], use = "pairwise.complete.obs"),2)


plot(q4$temp_anom, q4$gdp_noise, col = q4$yy)
text(q4$temp_anom, q4$gdp_noise+0.1, label = q4$yy, cex=0.5)

plot(q3$kbw_anom, q3$gdp_noise, col = q3$yy)
text(q3$kbw_anom, q3$gdp_noise+0.1, label = q3$yy, cex=0.5)


writexl::write_xlsx(dane, "data/dane.xlsx")
