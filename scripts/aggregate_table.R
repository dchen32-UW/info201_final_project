library(dplyr)

get_aggr_table_temp <- function(temp_data) {
  
}

get_aggr_table_disaster <- function(nd_data) {
  # calculate the mean natural disasters + global temp data
  #   from 1982 to 2012 the most recent 30 years
  present_5_years <- 
    natural_disaster_data %>%
    filter(year >= 1982 & year <= 2012) %>%
    group_by(disaster) %>%
    summarize(mean_count_present = mean(count, na.rm = TRUE),
              mean_damage_present = mean(damage, na.rm = TRUE),
              mean_land_ocean_temp_present = mean(mean_land_ocean_temp, na.rm = TRUE),
              mean_land_temp_present = mean(mean_land_temp, na.rm = TRUE))
  
  # calculate the mean natural disasters + global temp data
  #   from 1912 to 1942 the oldest 30 years
  past_5_years <-
    natural_disaster_data %>%
    filter(year >= 1912 & year <= 1942) %>%
    group_by(disaster) %>%
    summarize(mean_count_past = mean(count, na.rm = TRUE),
              mean_damage_past = mean(damage, na.rm = TRUE),
              mean_land_ocean_temp_past = mean(mean_land_ocean_temp, na.rm = TRUE),
              mean_land_temp_past = mean(mean_land_temp, na.rm = TRUE))
  # join them together and calculate differences
  differences <-
    left_join(past_5_years,
              present_5_years,
              by = c("disaster")) %>%
    mutate(count_diff =
             mean_count_present - mean_count_past,
           damage_diff =
             mean_damage_present - mean_damage_past,
           land_ocean_temp_diff =
             mean_land_ocean_temp_present - mean_land_ocean_temp_past,
           land_temp_diff =
             mean_land_temp_present - mean_land_temp_past) %>%
    select(disaster,
           count_diff,
           damage_diff,
           land_ocean_temp_diff,
           land_temp_diff)
  # rename columns
  colnames(differences) <-
    c("Disaster Type",
      "Difference in Count",
      "Difference in Economic Damage (USD)",
      "Difference in Mean Land Temperature",
      "Difference in Mean Land+Ocean Temperature")
  
  return(differences)
}