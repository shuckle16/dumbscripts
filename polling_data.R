library(stringr)
library(dplyr)

polls <- read.csv("~/bzan/3/tm/project/polling_data.csv")
polls <- polls[,c(1,2,grep(names(polls),pattern = "[Tt]rump"))]

polls$Trump <- as.numeric(as.character(polls$Trump))
polls$Date <- as.Date(paste(word(polls[,2],3),"/2015",sep=""),"%m/%d/%Y")
polls$week <- format.Date(polls$Date,"%U")


weekly_counts <- aggregate(title_df$trump_in_title~title_df$week,FUN=sum)
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


trump <- inner_join(weekly_polls,weekly_counts)
trump <- inner_join(trump_mentions,trump)

# granger tests 
library(MSBVAR)
granger.test(trump[2:3],1)
granger.test(trump[,3:4],1)
