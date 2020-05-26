library(dplyr)

#FUNCTION NOT FINISHED
get_summary_info_temp <- function(dataset) {
  result <- list()
  result$length <- nrow(dataset)
  #range of years
  result$range <- dataset %>%
    summarize(max_year = max(year, na.rm = TRUE),
              min_year = min(year, na.rm = TRUE))
  #number of unique countries (pull regions and unique)
  result$n_regions <-
    dataset %>%
    pull(region) %>%
    unique() %>%
    length()
  #country highest temp for all years
  result$country_highest_all_years <-
    dataset %>%
    filter(avg_temp == max(avg_temp, na.rm = TRUE))
  #country highest temp after 1988 (filter for > 1988)
  result$country_highest_after_1988 <-
    dataset %>%
    filter(year > 1988) %>%
    filter(avg_temp == max(avg_temp, na.rm = TRUE))
  #country highest temp before 1988 (filter for <= 1988)
  result$country_highest_before_1988 <-
    dataset %>%
    filter(year <= 1988) %>%
    filter(avg_temp == max(avg_temp, na.rm = TRUE))
  return(result)
}

#FUNCTION IS FINISHED
get_summary_info_disaster <- function(dataset) {
  result <- list()
  result$length <- nrow(dataset)
  #range of years
  result$range <- dataset %>%
    summarize(max_year = max(year, na.rm = TRUE),
              min_year = min(year, na.rm = TRUE))
  #year with most damage
  result$year_highest_economic_damage <- dataset %>%
    filter(damage == max(damage, na.rm = TRUE)) %>%
    slice(1)
  #year with most disasters
  result$year_highest_count <- dataset %>%
    filter(count == max(count, na.rm = TRUE)) %>%
    slice(1)
  #year with highest temp
  result$year_highest_temp <- dataset %>%
    filter(mean_land_ocean_temp == max(mean_land_ocean_temp, na.rm = TRUE)) %>%
    slice(1)
  #year with most damage per disaster
  result$year_highest_impact <- dataset %>%
    filter(disaster == "All natural disasters") %>%
    mutate(impact = damage / count) %>%
    filter(impact == max(impact, na.rm = TRUE)) %>%
    slice(1)
  return(result)
}

