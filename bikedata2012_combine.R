library(data.table)

# load the data by quarter
q1.2012 <- fread("./kaggle_BSD//2012-1st-quarter.csv")
q1.2012 <- subset(q1.2012, select=c("Start date", "Type"))
setnames(q1.2012, c("start.time", "type"))
dtg <- as.POSIXct(q1.2012$start.time, format="%m/%d/%Y %H:%M")
q1.2012 <- cbind(q1.2012, dtg)
q1.2012[, start.time := NULL]
setkey(q1.2012, dtg, type)

q2.2012 <- fread("./kaggle_BSD/2012-2nd-quarter.csv")
q2.2012 <- subset(q2.2012, select=c("Start date", "Bike Key"))
setnames(q2.2012, c("start.time", "type"))
dtg <- as.POSIXct(q2.2012$start.time, format="%m/%d/%Y %H:%M")
q2.2012 <- cbind(q2.2012, dtg)
q2.2012[, start.time := NULL]
setkey(q2.2012, dtg, type)

q3.2012 <- fread("./kaggle_BSD/2012-3rd-quarter.csv")
q3.2012 <- subset(q3.2012, select=c("Start date", "Subscriber Type"))
setnames(q3.2012, c("start.time", "type"))
dtg <- as.POSIXct(q3.2012$start.time, format="%m/%d/%Y %H:%M")
q3.2012 <- cbind(q3.2012, dtg)
q3.2012[, start.time := NULL]
setkey(q3.2012, dtg, type)

q4.2012 <- fread("./kaggle_BSD/2012-4th-quarter.csv")
q4.2012 <- subset(q4.2012, select=c("Start date", "Subscription Type"))
setnames(q4.2012, c("start.time", "type"))
dtg <- as.POSIXct(q4.2012$start.time, format="%m/%d/%Y %H:%M")
q4.2012 <- cbind(q4.2012, dtg)
q4.2012[, start.time := NULL]
setkey(q4.2012, dtg, type)

# combine data tables
bikedata <- rbind(q1.2012, q2.2012)
bikedata <- rbind(bikedata, q3.2012)
bikedata <- rbind(bikedata, q4.2012)

# convert categorial type into binary
casual <- rep(0, length(bikedata$type))
casual[bikedata$type=="Casual"] <- 1
registered <- rep(0, length(casual))
registered[casual==0] <- 1

# attach the new columns
bikedata <- cbind(bikedata, casual, registered)

# convert dtg to hourly
bikedata$datetime <- paste(substr(bikedata$dtg,12,13), ":00:00", sep="")
bikedata$datetime <- paste(substr(bikedata$dtg,1,10), bikedata$datetime)
# remove the categorial type column
bikedata[, type := NULL]
bikedata[, dtg := NULL]

#reset keys
setkey(bikedata, datetime)
setcolorder(bikedata, c("datetime", "casual", "registered"))

# sum by time and add count column
bikedata<- bikedata[,list(casual=sum(casual),registered=sum(registered)),
                    by=datetime]
bikedata[,count := casual + registered]
write.csv(bikedata, "bikedata_2012.csv")
