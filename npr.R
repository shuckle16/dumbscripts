library(rvest)
library(rjson)
library(stringr)

iterator <- 0
datez    <- as.character(seq(as.Date("2015/6/10"),Sys.Date(), "weeks"))

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

# build data frame of titles

legit_articles <- which(nchar(articlez) == 0)[1]-1


title_df <- data.frame(idz   = idz[1:legit_articles],
                       date  = as.Date(word(unlist(pubdatez[1:legit_articles]),2,4),"%d %b %Y"),
                       title = as.character(titlez[1:legit_articles]))

title_df$trump_in_title <- grepl("[Tt]rump",title_df$title)

title_df$week <- format(title_df$date,"%U")


trump_mentions <- aggregate(title_df$idz~title_df$week,FUN=length)
names(trump_mentions) <- c("week","mentions")

plot(trump_mentions,type="l")
lines(lowess(trump_mentions),col="red",lwd=2)
