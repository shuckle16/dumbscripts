library(rvest)
library(rjson)
library(stringr)

iterator <- 0
datez    <- as.character(seq(as.Date("2015/6/10"), as.Date("2015/10/20"), "weeks"))

idz      <- numeric(300)
articlez <- character(300)
pubdatez <- character(300)
titlez   <- character(300)

for (d in datez) {
  api_link <- paste("http://api.npr.org/query?startDate=",d,"&searchTerm=donald%20trump&dateType=story&sort=dateAsc&numResults=50&output=JSON&apiKey=MDIwNDU5NzMyMDE0NDIwODE2NzNkOWE0OA001",sep="")
  
  npr <- fromJSON(read_html(api_link) %>% html_text())$list$story
  
  for (j in 1:length(npr)) { 
    if (!(npr[[j]]$id %in% idz) & "fullText" %in% names(npr[[j]]) ) {
      iterator <- iterator + 1
      articlez[iterator]<-npr[[j]]$fullText
      idz[iterator] <- npr[[j]]$id
      pubdatez[iterator] <- npr[[j]]$storyDate
      titlez[iterator] <- npr[[j]]$title
    }
  }
}

legit_articles <- which(nchar(articlez) == 0)[1]-1

tempdf <- data.frame(cbind(idz[1:legit_articles],word(unlist(pubdatez[1:legit_articles]),2,4)))
tempdf$X2 <- as.Date(tempdf$X2,"%d %b %Y")
tempdf <- data.frame(cbind(tempdf,titlez=as.character(titlez[1:legit_articles])))
tempdf$trump_in_title <- grepl("[Tt]rump",tempdf$titlez)

plot(aggregate(tempdf$trump_in_title~tempdf$X2,FUN=function(x){return(sum(x))}),pch=20)
lines(lowess(aggregate(tempdf$trump_in_title~tempdf$X2,FUN=function(x){return(sum(x))})),col="red",lwd=2)
