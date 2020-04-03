#install.packages("MODISTools")
library(MODISTools)
library(raster)
library(rgdal)
library(dplyr)

# wspolrzedne = 
# Kusowo:  53.815100°,  16.588800°
# $Rzecin:  52°45'44.4"N 16°18'34.4"E

rzecin = c(52.7575, 16.30579)
kusowo = c(53.8151, 16.5888)
# (45*1.667)+(44.4*1.667)/100
# (18*1.667)+(34.4*1.667)/100

mod13q1_rzecin <- mt_subset(product = "MOD13Q1",
                            lat = rzecin[1],
                            lon =  rzecin[2],
                            band = "250m_16_days_NDVI",
                            start = "2000-02-18",
                            end = "2020-02-18",
                            km_lr = 0,
                            km_ab = 0,
                            site_name = "rzecin",
                            internal = TRUE,
                            progress = TRUE)

myd13q1_rzecin <- mt_subset(product = "MYD13Q1",
                            lat = rzecin[1],
                            lon = rzecin[2],
                            band = "250m_16_days_NDVI",
                            start = "2000-02-18",
                            end = "2020-02-18",
                            km_lr = 0,
                            km_ab = 0,
                            site_name = "rzecin",
                            internal = TRUE,
                            progress = TRUE)


mod13q1_kusowo <- mt_subset(product = "MOD13Q1",
                            lat = kusowo[1],
                            lon =  kusowo[2],
                            band = "250m_16_days_NDVI",
                            start = "2000-02-18",
                            end = "2020-02-18",
                            km_lr = 0,
                            km_ab = 0,
                            site_name = "kusowo",
                            internal = TRUE,
                            progress = TRUE)

myd13q1_kusowo <- mt_subset(product = "MYD13Q1",
                            lat = kusowo[1],
                            lon = kusowo[2],
                            band = "250m_16_days_NDVI",
                            start = "2000-02-18",
                            end = "2020-02-18",
                            km_lr = 0,
                            km_ab = 0,
                            site_name = "kusowo",
                            internal = TRUE,
                            progress = TRUE)


r = rbind.data.frame(myd13q1_kusowo, mod13q1_kusowo, myd13q1_kusowo, myd13q1_rzecin)

arcachon <- r %>% filter(value > -2000) %>% 
  #mutate(lc = ifelse(lc == 1, "ENF","DBF")) %>%
  group_by(calendar_date, site) %>% # group by lc and date
  summarize(doy = as.numeric(format(as.Date(calendar_date)[1],"%j")),
            ndvi_mean = median(value * as.double(scale)))


# plot LAI by date and per land cover class
library(tidyverse)
library(writexl)
writexl::write_xlsx(x = arcachon, path = "~/bogdan2.xlsx")
#ggplot(arcachon, aes(x = doy, y = ndvi_mean, colour = as.factor(lubridate::year(calendar_date)))) +
ggplot(arcachon, aes(x = as.factor(doy), y = ndvi_mean)) +  
  geom_boxplot() +
  #geom_line()+
  #geom_smooth(span = 0.5, method = "loess") +
  labs(x = "day of year (DOY)",
       y = "leaf area index (LAI)") +
  theme_minimal()+
  theme(legend.title = element_blank())+
  facet_wrap(~site)

library(tidyverse)
#spread(arcachon, )
#install.packages("MODISTools")

sessionInfo()
r1 <- MODISTools::mt_to_raster(df = mod13q1_rzecin, reproject = TRUE)
names(r1)
plot(r1[1])
dim(LC_r)
