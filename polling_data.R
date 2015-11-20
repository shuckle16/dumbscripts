library(stringr)
library(dplyr)

polls_real_clear <- read.csv("~/bzan/3/tm/project/polling_data.csv")
polls_real_clear <- polls_real_clear[,c(1,2,grep(names(polls_real_clear),pattern = "[Tt]rump"))]
polls_real_clear$Date <- as.Date(paste(word(polls_real_clear[,2],3),"/2015",sep=""),"%m/%d/%Y")
polls_real_clear$Trump <- as.numeric(as.character(polls_real_clear$Trump))
polls_real_clear$week <- format.Date(polls_real_clear$Date,"%U")

polls <- read.csv("http://elections.huffingtonpost.com/pollster/2016-national-gop-primary.csv")
polls <- polls[,c(1,3,grep(names(polls),pattern = "[Tt]rump"))]

polls$Trump <- as.numeric(as.character(polls$Trump))
polls$Date <- as.Date(polls$End.Date)
polls$week <- format.Date(polls$Date,"%U")


weekly_counts <- aggregate(title_df$trump_in_title~title_df$week,FUN=sum)
names(weekly_counts) <- c("week","trump_in_title")

weekly_polls <- aggregate(polls_real_clear$Trump~polls_real_clear$week,FUN=median)
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
