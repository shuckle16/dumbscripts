# messy (what webscraping isn't)

library(rvest)
library(rjson)

iterator <- 0
dts <- character(1000)
urls <- character(1000)
titles <- character(1000)

# loop through 100 pages from june 15
for (i in 1:100) {

  uri <- paste("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=donald+trump&begin_date=20150615&sort=oldest&page=",
               i,"&api-key=7f93af337b0212c846592746b610282e:3:73217497",sep="")

  page_json <- read_html(uri) %>%
    html_text %>%
    fromJSON()
  
  for (j in 1:(length(page_json$response$docs))) {
    iterator <- iterator + 1
    dts[iterator] <- page_json$response$docs[[j]]$pub_date
    urls[iterator] <- page_json$response$docs[[j]]$web_url
    titles[iterator] <- page_json$response$docs[[j]]$headline$main
  }
}

mydf <- as.data.frame(cbind(dts,titles,urls))

iterator <- 0
dts <- character(1000)
urls <- character(1000)
titles <- character(1000)


# loop backwards through 100 pages from today
for (i in 1:100) {
  
  uri <- paste("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=donald+trump&begin_date=20150615&sort=newest&page=",
               i,"&api-key=7f93af337b0212c846592746b610282e:3:73217497",sep="")
  
  page_json <- read_html(uri) %>%
    html_text %>%
    fromJSON()
  
  for (j in 1:(length(page_json$response$docs))) {
    iterator <- iterator + 1
    dts[iterator] <- page_json$response$docs[[j]]$pub_date
    urls[iterator] <- page_json$response$docs[[j]]$web_url
    titles[iterator] <- page_json$response$docs[[j]]$headline$main
  }
}

mydf2 <- as.data.frame(cbind(dts,titles,urls))

mydf3 <- rbind(mydf,mydf2)
mydf3$trump_in_title <- grepl("[Tt]rump",mydf3$titles)
mydf3$dts <- as.Date(substr(mydf3$dts,1,10))


# note did not get enough stuff from august 25 - 27

# filter out videos
mydf3 <- mydf3[-grep("video",mydf$urls),]


# getting the text 
# doesn't work yet

txt <- character(nrow(mydf3))
iterator2 <- 0

for (u in mydf3$urls) {
  iterator2 <- iterator2 + 1
  paras<-try(read_html(u))
  if (class(paras) != "try-error"){
    paras %>%
      html_nodes("p.p-block") %>%
      html_text() %>%
      unlist()
    
    paras <- paste(paras,collapse=" ")
    paras <- iconv(paras,"UTF-8","UTF-8")
    txt[iterator2] <- paras
  }
  
}
