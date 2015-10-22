library(rvest)
library(rjson)
datez <- as.character(seq(as.Date("2015/6/16"), as.Date("2015/7/15"), "days"))
articlez <- character(300)
idz <- numeric(300)
pubdatez <- character(300)
iterator <- 0

for (d in datez) {
  api_link <- paste("http://api.npr.org/query?startDate=",d,"&searchTerm=donald%20trump&dateType=story&sort=dateAsc&numResults=50&output=JSON&apiKey=MDIwNDU5NzMyMDE0NDIwODE2NzNkOWE0OA001",sep="")
  
  npr <- fromJSON(read_html(api_link) %>% html_text())$list$story
  
  for (j in 1:length(npr)) { 
    if (!(npr[[j]]$id %in% idz)) {
      iterator <- iterator + 1
      articlez[iterator]<-npr[[j]]$fullText
      idz[iterator] <- npr[[j]]$id
      pubdatez[iterator] <- npr[[j]]$storyDate
    }
  }
}

