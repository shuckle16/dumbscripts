# sentiment analysis

afinn_list <- read.delim(file='AFINN/AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
names(afinn_list) <- c('word', 'score')

articles_about_candidate <-articlez[which(title_df$candidate_in_title)]

sents <- numeric(length(articles_about_candidate))
for (i in 1:length(sents)) {
  words_in_article <- unlist(str_split(articles_about_candidate[i],"\\s+"))
  matches <- match(words_in_article,afinn_list[,1])
  tbl <- table(afinn_list[matches,2])
  
  sents[i] <- sum(as.numeric(rownames(tbl))*tbl)
}
plot(sents,type="l")


sents_df <- data.frame(title_df[which(title_df$candidate_in_title),],sents)

weekly_sents <- aggregate(sents_df$sents~sents_df$week,FUN=median)
names(weekly_sents) <- c("week","sent")

candidate_df <- left_join(candidate_df,weekly_sents)

granger.test(candidate_df[,c(3,5)],1)

plot_range <- range(rbind(candidate_df$candidate_poll,candidate_df$sent),na.rm=TRUE)

png(paste("plots/",candidate,".png",sep=""),width = 800, height= 547 )
plot(candidate_poll~week,data=candidate_df,type="l",ylim=plot_range,lwd=2
     ,main=paste(candidate,"'s poll numbers,mentions,and sentiments",sep=""))
lines(mentions~week,data=candidate_df,col="blue")
lines(sent~week,data=candidate_df,col="darkgreen")
legend("bottomright",c("polls","mentions","sentiment score"),col=c("black","blue","green"),lty=1)

dev.off()

