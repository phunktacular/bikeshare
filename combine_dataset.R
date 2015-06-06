library(data.table)
dt1 <- fread("test.csv")
dt2 <- fread("train.csv")
dt3 <- fread("bikedata_2011.csv")
dt4 <- fread("bikedata_2012.csv")

setkey(dt1, datetime, season, holiday, workingday, weather,
       temp, atemp, humidity, windspeed)
setkey(dt2, datetime, season, holiday, workingday, weather,
       temp, atemp, humidity, windspeed, casual, registered, count)
setkey(dt3, datetime, casual, registered, count)
setkey(dt4, datetime, casual, registered, count)

dt3[,V1:=NULL]
dt4[,V1:=NULL]
usage <- rbind(dt3, dt4)
x1 <- merge(dt1, usage, by="datetime")
cds <- rbind(dt2, x1)
setkey(cds, datetime)
write.csv(cds, "dataset_comp.csv")
