# topic modeling

topics <- LDA(DocumentTermMatrix(VCorpus(VectorSource(articlez[1:legit_articles]))),5)

get_terms(topics,10)

plot(posterior(topics)$topics[,2]~as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"),pch=20)
points(posterior(topics)$topics[,3]~as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"),pch=20,col="gray")


plot(aggregate(posterior(topics)$topics[,2]~format.Date(as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"), "%U"),FUN=function(x){return(length(which(x >= .5)))}),type="l")
