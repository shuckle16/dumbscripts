# republicans as of 11/22/2015

republicans <- c("donald trump", "ben carson", "carly fiorina",
                 "marco rubio", "jeb bush", "ted cruz",
                 "rand paul", "john kasich", "mike huckabee",
                 "chris christie", "rick santorum", "lindsey graham", "george pataki")


republican_df <- data.frame(name                   =character(),
                            mentions_implies_polls =numeric(),
                            polls_implies_mentions =numeric(),
                            total_mentions         =numeric(),
                            mentions_in_titles     =numeric(),
                            min_sent               =numeric(),
                            max_sent               =numeric())

for (candidate in republicans) {
  print(candidate)
  source("npr.R")
  source("polling_data.R")
  #source("testing.R")
  source("clean_npr_articles.R")
  source("sentiment_analysis_stuff.R")
  
  # to do 
  # save p-values from granger test to a dataframe
  # save sentiment scores of articles from some date to now
  
  new_row <- data.frame(name                   = candidate,
                        mentions_implies_polls = mip,
                        polls_implies_mentions = pim,
                        total_mentions         = t_m,
                        mentions_in_titles     = mit,
                        minsent                =)
  
  republican_df <- rbind(republican_df,new_row)
  
}
