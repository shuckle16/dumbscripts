urls <- as.character(read.table("~/bzan/3/tm/hw1/problem2.tsv")$twitter)

library(rvest)

twts <- data.frame()

for (url in urls[1:15]) {
tmstamp <- html_attr(html_nodes(html_nodes(html(url),"small.time"),"a"),"title")
twt <- html_text(html_nodes(html(url),"p.tweet-text"))
twts <- rbind(twts,cbind(rep(url,length(tmstamp)),tmstamp,twt))
}

twts$V1 <- as.character(twts$V1)
twts$tmstamp <- as.character(twts$tmstamp)
twts$twt <- as.character(twts$twt)

write.table(twts,"~/bzan/3/tm/hw2/tweets.tsv",sep="\t")
