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

week_starting_with <- function(dt) {
  min(dt) + 7*week_number(dt)
}
