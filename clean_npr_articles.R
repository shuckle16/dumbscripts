# clean NPR articles

library(stringr)
library(tm)

articlez <- articlez[1:legit_articles]

corp <- VCorpus(VectorSource(articlez))
path <- paste("articles/original/",cand_file_name,sep="")
dir.create(file.path(path), showWarnings = FALSE)
writeCorpus(corp,path=path)

articlez <- str_replace(string      = articlez,
                        pattern     = "Copyright 2015 NPR. To see more, visit http://www.npr.org/.",
                        replacement = "")

articlez <- str_replace(string      = articlez,
                        pattern     = "(f|ht)(tp)(s?)(://)(.*)[.][a-z]{2,6}", 
                        replacement = "")

articlez <- str_to_lower(articlez)
articlez <- removeWords(articlez,stopwords())
articlez <- removeNumbers(articlez)
articlez <- removePunctuation(articlez)

cleaned_corp <- VCorpus(VectorSource(articlez))
path <- paste("articles/clean/",cand_file_name,sep="")
dir.create(file.path(path), showWarnings = FALSE)
writeCorpus(cleaned_corp,path=path)
