# topic modeling

library(topicmodels)

topics <- LDA(DocumentTermMatrix(VCorpus(VectorSource(articlez))),2)

get_terms(topics,10)

plot(posterior(topics)$topics[,1]~as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"),pch=20)
points(posterior(topics)$topics[,2]~as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"),pch=20,col="gray")


plot(aggregate(posterior(topics)$topics[,1]~format.Date(as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"), "%U"),FUN=function(x){return(length(which(x >= .5)))}),type="l")

topics_df <- aggregate(posterior(topics)$topics[,1]~format.Date(as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"), "%U"),FUN=function(x){return(length(which(x >= .5)))})
names(topics_df) <- c("week","topic_count")

topics_df2 <- aggregate(posterior(topics)$topics[,2]~format.Date(as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"), "%U"),FUN=function(x){return(length(which(x >= .5)))})
names(topics_df2) <- c("week","topic_count2")

topics_df <- inner_join(topics_df,topics_df2)

candidate_df <- inner_join(candidate_df,topics_df)

candidate_df$topic_count3 <- candidate_df$topic_count + candidate_df$topic_count2

plot(candidate_df$candidate_poll~candidate_df$week,type="o",ylim=c(0,40))
lines(candidate_df$topic_count~candidate_df$week,type="o")

granger.test(candidate_df[,c(3,5)],1)
