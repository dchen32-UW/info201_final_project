library(dplyr)
source("data_cleaning.R")

# DATASET 1
# get clean average temperature by country dataset
avg_country_temp_data <-
  get_clean_avg_country_temp(avg_temp_by_country)

get_summary_info_temp <- function(dataset) {
  result <- list()
  result$length <- nrow(dataset)
  return(result)
}

temp_summary_info <- get_summary_info_temp(avg_country_temp_data)

# DATASET 2
# get clean combined natural disaster count, damage, and temp dataset
natural_disaster_data <-
  get_clean_natural_disaster(global_temp,
                             natural_disaster_count,
                             natural_disaster_damage)

get_summary_info_disaster <- function(dataset) {
  result <- list()
  result$length <- nrow(dataset)
  return(result)
}

disaster_summary_info <- get_summary_info_disaster(natural_disaster_data)