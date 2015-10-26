library(stringr)
polls <- read.csv("~/bzan/3/tm/project/polling_data.csv")
polls <- polls[,1:3]

polls$Trump <- as.numeric(as.character(polls$Trump))

polls$Date <- as.Date(paste(word(polls[,2],3),"/2015",sep=""),"%m/%d/%Y")

plot(aggregate(polls$Trump~polls$Date,FUN=median),pch=20,cex=.4,main="Trump's Polling Average")
lines(lowess(aggregate(polls$Trump~polls$Date,FUN=median)),col="blue",lwd=2)


length(unique(format.Date(tempdf$X2,"%U")))


plot(aggregate(polls$Trump~format.Date(polls$Date,"%U"),FUN=median),pch=20,cex=.4)
points(aggregate(tempdf$trump_in_title~format.Date(tempdf$X2,"%U"),FUN=function(x){return(sum(x))}),pch=20,cex=.4,col="blue")


lines(aggregate(polls$Trump~format.Date(polls$Date,"%U"),FUN=median),lwd=1,lty=2)
lines(aggregate(tempdf$trump_in_title~format.Date(tempdf$X2,"%U"),FUN=function(x){return(sum(x))}),lwd=1,lty=2,col="blue")

lines(lowess((aggregate(polls$Trump~format.Date(polls$Date,"%U"),FUN=median))),col="black",lwd=3)
lines(lowess(aggregate(tempdf$trump_in_title~format.Date(tempdf$X2,"%U"),FUN=function(x){return(sum(x))})),lwd=3,col="blue")


weekly_counts <- aggregate(tempdf$trump_in_title~format.Date(tempdf$X2,"%U"),FUN=sum)
names(weekly_counts) <- c("week","trump_in_title")

weekly_polls <- aggregate(polls$Trump~format.Date(polls$Date,"%U"),FUN=mean)
names(weekly_polls) <- c("week","trump_poll")

newdf <- inner_join(weekly_polls,weekly_counts)

cor(newdf$trump_poll,newdf$trump_in_title)


summary(lm(trump_poll~trump_in_title+as.numeric(as.character(week)),data=newdf))


#install.packages("MSBVAR")
library(MSBVAR)
granger.test(newdf[2:3],1)
