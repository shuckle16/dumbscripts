# republicans as of 11/22/2015

republicans <- c("donald trump", "ben carson", "carly fiorina",
                 "marco rubio", "jeb bush", "ted cruz",
                 "rand paul", "john kasich", "mike huckabee",
                 "chris christie", "rick santorum", "lindsey graham", "george pataki")


for (candidate in republicans) {
  source("npr.R")
  source("polling_data.R")
  source("clean_npr_articles.R")
  source("sentiment_analysis_stuff.R")
  
  # to do
  # save p-values from granger test to a dataframe
  # save sentiment scores of articles from some date to now
}
