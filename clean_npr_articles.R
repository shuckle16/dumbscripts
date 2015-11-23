# clean NPR articles

library(stringr)
library(tm)

articlez <- articlez[1:legit_articles]

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
