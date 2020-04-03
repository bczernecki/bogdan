opad = readRDS("data/opad_caly.rds")
head(opad)
kbw = readRDS("data/kbw_caly.rds")
head(kbw)

dane = data.frame(data = opad$data, opad = opad$opad, kbw = kbw$kbw)
library(tidyverse)
head(dane)
dane$yy = lubridate::year(dane$data)
dane$mm = lubridate::month(dane$data)
srednie = dane %>% group_by(mm) %>% summarise(opad2 = mean(opad),
                                    kbw2 =  mean(kbw))

head(dane)
head(srednie)
dane$opad_anom = round(dane$opad - srednie$opad2,2)
dane$kbw_anom = round(dane$kbw - srednie$kbw2,2)
head(dane)

temp = readRDS("data/temperatura_caly.rds")
dane$temp = round(temp$value,2)
head(dane)

df = dplyr::select(dane, yy:temp)
head(df)
colnames(df)[5] = "temp_anom"
saveRDS(df, "data/anomalie.rds")

# df2 = dplyr::select(dane, data, temp, opad, kbw)
# writexl::write_xlsx(df2, "data/dane_meteo.xlsx")
