library(rvest)
library(rjson)
library(stringr)
library(tm)
library(lubridate)

get_text_npr <- function(candidate="donald trump",api_key="your_api_key") {
  
  fname <- word(candidate,1)
  lname <- word(candidate,2)
  
  cand_file_name <- str_replace(candidate," ","")
  
  iterator <- 0
  datez    <- as.character(seq(as.Date("2015/6/10"),as.Date(Sys.Date()), "weeks"))
  
  idz      <- numeric(300)
  articlez <- character(300)
  pubdatez <- character(300)
  titlez   <- character(300)
  
  for (d in datez) {
    api_link <- paste("http://api.npr.org/query?startDate=",d,"&searchTerm=",fname,"%20",lname,"&dateType=story&sort=dateAsc&numResults=50&output=JSON&apiKey=MDIwNDU5NzMyMDE0NDIwODE2NzNkOWE0OA001",sep="")
    
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
  
  num_legit_articles <- which(nchar(articlez) == 0)[1]-1
  
  article_df <- data.frame(id=as.character(idz),dt=as.character(unlist(pubdatez)),
                           title=as.character(unlist(titlez)),text=as.character(unlist(articlez))
                           ,stringsAsFactors = FALSE)
  
  article_df    <- article_df[1:num_legit_articles,]
  article_df$dt <- as.Date(word(article_df$dt,2,4),"%d %b %Y")
  
  article_df
}

get_polls_huffpost <- function(candidate="trump",party="gop") {
  polls <- read.csv(paste("http://elections.huffingtonpost.com/pollster/2016-national-",party,"-primary.csv",sep=""),stringsAsFactors = FALSE)
  polls <- polls[,c(1,3,grep(names(polls),pattern = candidate,ignore.case=TRUE))]
  
  polls$End.Date <- as.Date(polls$End.Date)
  names(polls) <- c("pollster","date","pct_vote")
  
  polls
}


