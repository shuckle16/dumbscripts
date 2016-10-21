first_of_month <- function(dt) {
  as.Date(paste(month(dt),"01",year(dt)),"%m %d %Y")
}

week_number <- function(dt,start_year=2015) {
  week(dt) + 52*(year(dt) - start_year)
}
