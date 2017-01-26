first_of_month <- function(dt) {
  as.Date(paste(month(dt),"01",year(dt)),"%m %d %Y")
}

week_number <- function(dt,start_year=NULL) {
  if(is.null(start_year)) {
    week(dt) + 52*(year(dt) - year(min(dt)))
  } else {
    week(dt) + 52*(year(dt) - start_year)
  }
}

week_of <- function(dt) {
  min(dt) + 7*(week_number(dt)-1)
}

# assumes dt is ordered
#week_of <- function(dt) {
#  rep(seq(min(dt),max(dt), 7),7)
#}
