# This example is adapted from http://andybromberg.com/sentiment-analysis/
setwd("bzan/3/tm/project/")

#install.packages(c("plyr","stringr","e1071"))
library(plyr)
library(stringr)
library(e1071)

# The AFINN wordlist found at http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010
# which has 2477 words and phrases rated from -5 [very negative] to +5 [very positive]. 
afinn_list <- read.delim(file='AFINN/AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
names(afinn_list) <- c('word', 'score')
head(afinn_list)

#########################################
# Categorize words as very negative to  #
# very positive and add some            #
# movie-specific words                  #
#########################################

# We reclassify the AFINN words into four categories:
#  - Very Negative (rating -5 or -4)
#  - Negative (rating -3, -2, or -1)
#  - Positive (rating 1, 2, or 3)
#  - Very Positive (rating 4 or 5)
# We also add in a few more words specific to movies found here: 
# http://member.tokoha-u.ac.jp/~dixonfdm/Writing%20Topics%20htm/Movie%20Review%20Folder/movie_descrip_vocab.htm
# to round out our wordlist. 

vNegTerms <- afinn_list$word[afinn_list$score==-5 | afinn_list$score==-4]
negTerms  <- c(afinn_list$word[afinn_list$score==-3 | afinn_list$score==-2 | afinn_list$score==-1], 
	"second-rate", "moronic", "third-rate", "flawed", "juvenile", "boring", "distasteful", "ordinary", 
	"disgusting", "senseless", "static", "brutal", "confused", "disappointing", "bloody", "silly", "tired", 
	"predictable", "stupid", "uninteresting", "trite", "uneven", "outdated", "dreadful", "bland")
posTerms  <- c(afinn_list$word[afinn_list$score==3 | afinn_list$score==2 | afinn_list$score==1], 
	"first-rate", "insightful", "clever", "charming", "comical", "charismatic", "enjoyable", "absorbing", 
	"sensitive", "intriguing", "powerful", "pleasant", "surprising", "thought-provoking", "imaginative", 
	"unpretentious")
vPosTerms <- c(afinn_list$word[afinn_list$score==5 | afinn_list$score==4], "uproarious", "riveting", 
	"fascinating", "dazzling", "legendary")

#function to calculate number of words in each category within a sentence
sentimentScore <- function(sentences, vNegTerms, negTerms, posTerms, vPosTerms){
	final_scores <- matrix('', 0, 5)
	scores <- laply(sentences, function(sentence, vNegTerms, negTerms, posTerms, vPosTerms){
		initial_sentence <- sentence

		# remove unnecessary characters and split up by word 
		sentence <- gsub('[[:punct:]]', '', sentence)
		sentence <- gsub('[[:cntrl:]]', '', sentence)
		sentence <- gsub('\\d+', '', sentence)
		sentence <- tolower(sentence)
		wordList <- str_split(sentence, '\\s+')
		words <- unlist(wordList)

		# build vector with matches between sentence and each category
		vPosMatches <- match(words, vPosTerms)
		posMatches <- match(words, posTerms)
		vNegMatches <- match(words, vNegTerms)
		negMatches <- match(words, negTerms)

		# sum up number of words in each category
		vPosMatches <- sum(!is.na(vPosMatches))
		posMatches <- sum(!is.na(posMatches))
		vNegMatches <- sum(!is.na(vNegMatches))
		negMatches <- sum(!is.na(negMatches))
		score <- c(vNegMatches, negMatches, posMatches, vPosMatches)

		# add row to scores table
		newrow <- c(initial_sentence, score)
		final_scores <- rbind(final_scores, newrow)
		return(final_scores)
	}, vNegTerms, negTerms, posTerms, vPosTerms)
	return(scores)
}


sentiments <- data.frame(sentimentScore(articlez[which(tempdf$trump_in_title)],vNegTerms,negTerms,posTerms,vPosTerms))
sentiments[,2:5] <- apply(sentiments[,2:5],2,as.numeric)

sentiments$weighted_sentiment <- -1*sentiments[,2] + -1*sentiments[,3] + 1*sentiments[,4] + 1*sentiments[,5]

sentiments$date <-as.Date(word(unlist(pubdatez[which(tempdf$trump_in_title)]),2,4),"%d %b %Y")
sentiments$week <- format(sentiments$date, "%U")

sentiments$word_count <- sapply(gregexpr("\\W+", sentiments[,1]), length) + 1
# get sentiment words as a percentage of the total words in each article
# apply(sentiments[,2:5],2,FUN=function(x){return(x/sentiments$word_count)})

weekly_sentiments <- aggregate((sentiments$weighted_sentiment/sentiments$word_count)~sentiments$week,FUN=mean)
names(weekly_sentiments) <- c("week","sentiment_score")

plot(weekly_sentiments,type="l")
s
trump <- inner_join(trump,weekly_sentiments)

trump$sentiment_score > 0

plot(trump$trump_poll~trump$week,type="l",ylim=c(-5,40))
lines(100*trump$sentiment_score~trump$week)






table(afinn_list[match(unlist(str_split(articlez[which(tempdf$trump_in_title)][1],"\\s+")),afinn_list[,1]),2])

sents <- numeric(82)
for (i in 1:82) {
sents[i] <- sum(as.numeric(rownames(table(afinn_list[match(unlist(str_split(articlez[which(tempdf$trump_in_title)][i],"\\s+")),afinn_list[,1]),2]))) * table(afinn_list[match(unlist(str_split(articlez[which(tempdf$trump_in_title)][i],"\\s+")),afinn_list[,1]),2]))
}
plot(sents,type="l")
