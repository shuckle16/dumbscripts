library(stringr)
library(dplyr)
polls <- read.csv("~/bzan/3/tm/project/polling_data.csv")
polls <- polls[,c(1,2,4)]

polls$Trump <- as.numeric(as.character(polls$Trump))
polls$Date <- as.Date(paste(word(polls[,2],3),"/2015",sep=""),"%m/%d/%Y")
polls$week <- format.Date(polls$Date,"%U")

tempdf$week <- format.Date(tempdf$X2,"%U")

weekly_counts <- aggregate(tempdf$trump_in_title~tempdf$week,FUN=sum)
names(weekly_counts) <- c("week","trump_in_title")

weekly_polls <- aggregate(polls$Trump~polls$week,FUN=median)
names(weekly_polls) <- c("week","trump_poll")

plot(weekly_polls,pch=20,cex=.4,main="Trump's Polling Average", 
     xlab="week of 2015",ylab="Polling Percentage (median)")
points(weekly_counts,pch=20,cex=.4,col="blue")


lines(weekly_polls,lwd=1,lty=2)
lines(weekly_counts,lwd=1,lty=2,col="blue")

lines(lowess(weekly_polls),lwd=3,col="black")
lines(lowess(weekly_counts),lwd=3,col="blue")


newdf <- inner_join(weekly_polls,weekly_counts)

cor(newdf$trump_poll,newdf$trump_in_title)

#install.packages("MSBVAR")
library(MSBVAR)
granger.test(newdf[2:3],1)



trump <- inner_join(trump_mentions,newdf)

granger.test(trump[,2:3],1)
