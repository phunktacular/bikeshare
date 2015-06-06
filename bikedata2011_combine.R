# load the useage data
q1.2011 <- read.csv("./kaggle_BSD/2011-1st-quarter.csv")
q2.2011 <- read.csv("./kaggle_BSD/2011-2nd-quarter.csv")
q3.2011 <- read.csv("./kaggle_BSD/2011-3rd-quarter.csv")
q4.2011 <- read.csv("./Kaggle_BSD/2011-4th-quarter.csv")

# combine the data frames for 2011
bikedata<- rbind(q1.2011, q2.2011, q3.2011, q4.2011)
rm(list=c("q1.2011", "q2.2011", "q3.2011", "q4.2011"))

# convert the date/time info into the right format
bikedata$start.time <- strptime(as.character(bikedata[,2]),"%m/%d/%Y %H:%M")

# remove unused components
bikedata <- bikedata[-1:-6]

# find the hour is which useage occurred
bikedata$datetime <- paste(substr(bikedata[,2],12,13), ":00:00", sep="")

# add the date to the useage hour
bikedata$datetime <- paste(substr(bikedata[,2],1,10), bikedata$datetime)

# convert categorial member type to binary
casual <- rep(0, length(bikedata$Member.Type))
casual[bikedata$Member.Type=="Casual"] <- 1
registered <- rep(0, length(casual))
registered[casual==0] <- 1

# add casual and registered counts into data frame
bikedata <- cbind(bikedata, casual, registered)
# remove Member.Type and start.time from data frame
bikedata <- bikedata[-1:-2]

# sum the casual and registered users
library(data.table)
dt.bikedata <- as.data.table(bikedata)

bikedata<- dt.bikedata[,list(casual=sum(casual),registered=sum(registered)),
                       by=datetime]
setkey(bikedata, datetime)
bikedata[,count := casual + registered]
write.csv(bikedata, "bikedata_2011.csv")
