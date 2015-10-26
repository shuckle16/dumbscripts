library(stringr)
polls <- read.csv("~/bzan/3/tm/project/polling_data.csv")
polls <- polls[,1:3]

polls$Trump <- as.numeric(as.character(polls$Trump))

polls$Date <- as.Date(paste(word(polls[,2],3),"/2015",sep=""),"%m/%d/%Y")

plot(aggregate(polls$Trump~polls$Date,FUN=median),pch=20,cex=.4,main="Trump's Polling Average")
lines(lowess(aggregate(polls$Trump~polls$Date,FUN=median)),col="blue",lwd=2)
