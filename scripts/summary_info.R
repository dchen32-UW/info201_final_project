library(dplyr)

get_summary_info_temp <- function(dataset) {
  result <- list()
  result$length <- nrow(dataset)
  return(result)
}

get_summary_info_disaster <- function(dataset) {
  result <- list()
  result$length <- nrow(dataset)
  return(result)
}