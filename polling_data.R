library(stringr)
library(dplyr)

polls_real_clear <- read.csv("polling_data.csv")
polls_real_clear <- polls_real_clear[,c(1,2,grep(names(polls_real_clear),pattern = lname,ignore.case = TRUE))]
polls_real_clear$Date <- as.Date(paste(word(polls_real_clear[,2],3),"/2015",sep=""),"%m/%d/%Y")
names(polls_real_clear) <- c("Poll","Date","candidate")

polls_real_clear$candidate <- as.numeric(as.character(polls_real_clear$candidate))
polls_real_clear$week <- format.Date(polls_real_clear$Date,"%U")

polls <- read.csv("http://elections.huffingtonpost.com/pollster/2016-national-gop-primary.csv")
polls <- polls[,c(1,3,grep(names(polls),pattern = "[Tt]rump"))]

polls$Trump <- as.numeric(as.character(polls$Trump))
polls$Date <- as.Date(polls$End.Date)
polls$week <- format.Date(polls$Date,"%U")


weekly_counts <- aggregate(title_df$candidate_in_title~title_df$week,FUN=sum)
names(weekly_counts) <- c("week","candidate_in_title")

weekly_polls <- aggregate(polls_real_clear$candidate~polls_real_clear$week,FUN=median)
names(weekly_polls) <- c("week","candidate_poll")

plot(weekly_polls,pch=20,cex=.4,main=paste(lname,"'s Polling Average",sep=""), 
     xlab="week of 2015",ylab="Polling Percentage (median)",ylim=c(0,max(weekly_polls[,2])))
#points(weekly_counts,pch=20,cex=.4,col="blue")
points(candidate_mentions,pch=20,cex=.4,col="blue")


lines(weekly_polls,lwd=1,lty=2)
#lines(weekly_counts,lwd=1,lty=2,col="blue")
lines(candidate_mentions,lwd=1,lty=2,col="blue")

lines(lowess(weekly_polls),lwd=3,col="black")
#lines(lowess(weekly_counts),lwd=3,col="blue")
lines(lowess(candidate_mentions),lwd=3,col="blue")

candidate_df <- inner_join(weekly_polls,weekly_counts)
candidate_df <- inner_join(candidate_mentions,candidate_df)

# granger tests 
library(MSBVAR)
pim <- granger.test(candidate_df[2:3],1)[1,2]
mip <- granger.test(candidate_df[2:3],1)[2,2]

#granger.test(candidate_df[3:4],2)
