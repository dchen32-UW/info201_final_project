library(dplyr)

# gets summary information and takeaway points for takeaway 3
# parameters:
#   temp_data : dataframe with all of the temperature measurments per country
# returns:
#   result : vector with the country with the max and min temp change
get_summary3_countries <- function(temp_data) {
  temp_2012 <-
    temp_data %>%
    filter(year == 2012) %>%
    group_by(region) %>%
    summarise(mean_temp_2012 = mean(avg_temp, na.rm = TRUE))

  temp_1912 <-
    temp_data %>%
    filter(year == 1912) %>%
    group_by(region) %>%
    summarise(mean_temp_1912 = mean(avg_temp, na.rm = TRUE))

  temp_diff <-
    left_join(temp_1912, temp_2012) %>%
    mutate(mean_temp_diff = mean_temp_2012 - mean_temp_1912)

  temp_diff <- temp_diff[complete.cases(temp_diff), ]

  max_temp_country <-
    temp_diff %>%
    filter(mean_temp_diff == max(mean_temp_diff, na.rm = TRUE)) %>%
    pull(region)

  min_temp_country <-
    temp_diff %>%
    filter(mean_temp_diff == min(mean_temp_diff, na.rm = TRUE)) %>%
    pull(region)

  result <- c(min_temp_country, max_temp_country)
  return(result)
}
