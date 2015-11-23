setwd("~/bzan/3/tm/project/")

afinn_list <- read.delim(file='AFINN/AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
names(afinn_list) <- c('word', 'score')


table(afinn_list[match(unlist(str_split(articlez[which(title_df$candidate_in_title)][1],"\\s+")),afinn_list[,1]),2])

sents <- numeric(83)
for (i in 1:83) {
  sents[i] <- sum(as.numeric(rownames(table(afinn_list[match(unlist(str_split(articlez[which(title_df$candidate_in_title)][i],"\\s+")),afinn_list[,1]),2]))) * table(afinn_list[match(unlist(str_split(articlez[which(title_df$candidate_in_title)][i],"\\s+")),afinn_list[,1]),2]))
}
plot(sents,type="l")


sents_df <- data.frame(title_df[which(title_df$candidate_in_title),],sents)

weekly_sents <- aggregate(sents_df$sents~sents_df$week,FUN=median)
names(weekly_sents) <- c("week","sent")

granger.test(test_sent[,c(2,4)],1)
