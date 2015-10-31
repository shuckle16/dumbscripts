# clean NPR articles

library(stringr)

articlez <- str_replace(string = articlez,
            pattern = "Copyright 2015 NPR. To see more, visit http://www.npr.org/.",
            replacement = "")

articlez <- str_to_lower(articlez)
articlez <- removeWords(articlez,stopwords())
articlez <- removeNumbers(articlez)
articlez <- removePunctuation(articlez)
