# scrapes NPR for mentions of candidates in the 2016 presidential election
# scrapes Huffpost and aggregates polls by week of the election
# does a Granger test to see if changes in polls => changes in mentions

library(tidyverse,quietly=TRUE)
library(stringr)
library(MSBVAR)

candidate <- "donald trump"
fname     <- word(candidate,1)
lname     <- word(candidate,2)

text_data       <- get_text_npr(candidate)
text_data$week  <- week_number(text_data$dt)

polls      <- get_polls_huffpost(lname)
polls$week <- week_number(polls$date)

polls <- 
  polls %>% 
  group_by(week) %>% 
  summarize(median_poll=median(pct_vote))  

cand_mentions <- 
  text_data %>% 
  group_by(week) %>% 
  summarize(mentions=n())

m_p <- inner_join(cand_mentions,polls)

m_p %>%
  na.omit() %>%
  gather(measure,value,-week) %>%
  ggplot(aes(x=week,y=value,group=measure,color=measure)) +
    geom_line() + 
    ggtitle("Polls and NPR mentions")

granger.test(data.frame(lapply(m_p[,2:3],diff)),1)
