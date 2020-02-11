df = read.table("data/poltemp_new.txt", stringsAsFactors = F)

library(tidyverse)
head(df)
df = df %>% select(V1:V13)
head(df)

tail(df)
df2 = filter(df, V1 > 1986)

colMeans(df2)
anomal = rbind(c(00, apply(df2, 2, mean)[-1]))
anomal
df2- anomal

anomal2 = as.data.frame(matrix(rep(anomal, each=33), ncol = 13))

head(df2)
head(anomal2)
temp = df2-anomal2
colnames(temp)[1] = "yy"

head(temp)
library(tidyverse)
temp2 = gather(temp, key = "key", value = "value", -1)

filter(temp2, key == "V3") %>% .[,3] %>% mean()

head(temp2)
temp2$key = gsub("V", "", temp2$key)
temp2$key = as.numeric(temp2$key)
temp2 = arrange(temp2, yy, key)
temp2$key = temp2$key - 1
head(temp2)

temp2$data = as.Date(paste(temp2$yy, temp2$key, "01", sep="-"))
head(temp2)
temp2 = select(temp2, data, value)
head(temp2)
plot(temp2)

plot(temp2 %>% group_by(lubridate::year(data)) %>% summarise(mean(value)))

saveRDS(temp2, file='data/temperatura_caly.rds')
