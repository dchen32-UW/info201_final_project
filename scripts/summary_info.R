library(dplyr)

# gather summary information for DATASET 1, inquires about the number of
#   observations in the dataset, its breadth in terms of years covered,
#   the number of unique regions and the country with the highest average
#   temperature before or during 1988, after 1988, and during all time
# parameters:
#   - dataset = dataframe of mean land temperature by country
get_summary_info_temp <- function(dataset) {
  # set up a new empty list to store results
  result <- list()
  # add number of observations
  result$length <- nrow(dataset)
  # range of years
  result$range <- dataset %>%
    summarize(max_year = max(year, na.rm = TRUE),
              min_year = min(year, na.rm = TRUE))
  # number of unique countries (pull regions and unique)
  result$n_regions <-
    dataset %>%
    pull(region) %>%
    unique() %>%
    length()
  # country highest temp for all years
  result$country_highest_all_years <-
    dataset %>%
    filter(avg_temp == max(avg_temp, na.rm = TRUE))
  # country highest temp after 1988 (filter for > 1988)
  result$country_highest_after_1988 <-
    dataset %>%
    filter(year > 1988) %>%
    filter(avg_temp == max(avg_temp, na.rm = TRUE))
  # country highest temp before 1988 (filter for <= 1988)
  result$country_highest_before_1988 <-
    dataset %>%
    filter(year <= 1988) %>%
    filter(avg_temp == max(avg_temp, na.rm = TRUE))

  return(result)
}

# gather summary information for DATASET 2, inquires about the number of
#   observations in the dataset, its breadth in terms of years covered, and the
#   years with the highest number of natural disasters, highest mean land
#   land temperature, highest impact (defined as damage / count) and highest
#   economic damage when only considering all natural disasters
# parameters:
#   - dataset = dataframe of natural disaster information and associated
#               global temperature information with "all natural disaster"
#               row for each group of observations
get_summary_info_disaster <- function(dataset) {
  # set up a new empty list to store results
  result <- list()
  # add number of observations
  result$length <- nrow(dataset)
  # range of years
  result$range <- dataset %>%
    summarize(max_year = max(year, na.rm = TRUE),
              min_year = min(year, na.rm = TRUE))
  # year with highest temp
  result$year_highest_temp <-
    dataset %>%
    filter(disaster == "All natural disasters") %>%
    filter(mean_land_ocean_temp ==
             max(mean_land_ocean_temp, na.rm = TRUE)) %>%
    slice(1)
  # year with most disasters
  result$year_highest_count <-
    dataset %>%
    filter(disaster == "All natural disasters") %>%
    filter(count == max(count, na.rm = TRUE)) %>%
    slice(1)
  # year with most damage
  result$year_highest_economic_damage <-
    dataset %>%
    filter(disaster == "All natural disasters") %>%
    filter(damage == max(damage, na.rm = TRUE)) %>%
    slice(1)
  # year with most damage per disaster
  result$year_highest_impact <-
    dataset %>%
    filter(disaster == "All natural disasters") %>%
    mutate(impact = damage / count) %>%
    filter(impact == max(impact, na.rm = TRUE)) %>%
    slice(1)

  return(result)
}
<<<<<<< HEAD

=======
>>>>>>> fb5e62f1bc685e5c1399694db0500ee40f21606f
