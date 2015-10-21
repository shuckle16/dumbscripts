library(rvest)
library(rjson)
datez <- seq(as.Date("2015/6/16"), as.Date("2015/6/21"), "days")
articlez <- character(300)
iterator <- 0

for (d in datez) {
  api_link <- paste("http://api.npr.org/query?startDate=",datez[1],"&searchTerm=donald%20trump&dateType=story&sort=dateAsc&numResults=50&output=JSON&apiKey=MDIwNDU5NzMyMDE0NDIwODE2NzNkOWE0OA001",sep="")
  
  npr <- fromJSON(read_html(api_link) %>% html_text())$list$story
  
  for (j in 1:length(npr)) { 
    iterator <- iterator + 1
    articlez[iterator]<-npr[[j]]$fullText
  }
}

