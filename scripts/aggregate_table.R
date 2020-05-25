library(dplyr)
library(countrycode)

get_aggr_table_temp <- function(temp_data) {
  # get continent information
  temp_data <-
    temp_data %>%
    mutate(country = region) %>%
    mutate(
      region = 
        temp_data %>%
        pull(region) %>%
        countrycode("country.name",
                    "region")
    )
  # remove NA values, basically countries that did not match to continents
  temp_data <- temp_data[complete.cases(temp_data), ]
  # compute by continent grouped values
  # compute most present 30 years
  present_30_years <-
    temp_data %>%
    filter(year >= 1982 & year <= 2012) %>%
    group_by(region) %>%
    summarize(mean_land_temp_present
              = mean(avg_temp, na.rm = TRUE))
  # compute past 30 years
  past_30_years <-
    temp_data %>%
    filter(year >= 1912 & year <= 1942) %>%
    group_by(region) %>%
    summarize(mean_land_temp_past
              = mean(avg_temp, na.rm = TRUE))
  # compute ancient 30 years
  ancient_30_years <-
    temp_data %>%
    filter(year >= 1842 & year <= 1872) %>%
    group_by(region) %>%
    summarize(mean_land_temp_ancient
              = mean(avg_temp, na.rm = TRUE))
  # compute change
  differences <-
    left_join(ancient_30_years,
              past_30_years,
              by = c("region")) %>%
    left_join(present_30_years,
              by = c("region")) %>%
    mutate(previous_mean_land_temp_diff =
             mean_land_temp_past - mean_land_temp_ancient,
           recent_mean_land_temp_diff =
             mean_land_temp_present - mean_land_temp_past,
           overall_mean_land_temp_diff =
             mean_land_temp_present - mean_land_temp_ancient) %>%
    mutate(change_between_changes =
             recent_mean_land_temp_diff - previous_mean_land_temp_diff) %>%
    arrange(-overall_mean_land_temp_diff)
  # rename columns
  colnames(differences) <- c("Region",
                             "Ancient Mean Land Temperature (˚C)",
                             "Past Mean Land Temperature (˚C)",
                             "Present Mean Land Temperature (˚C)",
                             "Previous Change in Mean Land Temperature (˚C)",
                             "Recent Change in Mean Land Temperature (˚C)",
                             "Overall Change in Mean Land Temperature (˚C)",
                             "Change Between Recent and Previous Changes (˚C")
  return(differences)
}

get_aggr_table_disaster <- function(nd_data) {
  # calculate the mean natural disasters + global temp data
  #   from 1982 to 2012 the most recent 30 years
  present_30_years <- 
    natural_disaster_data %>%
    filter(year >= 1982 & year <= 2012) %>%
    mutate(impact = (damage / 1000000000) / count) %>%
    group_by(disaster) %>%
    summarize(mean_count_present = mean(count, na.rm = TRUE),
              mean_damage_present = mean(damage, na.rm = TRUE),
              mean_impact_present = mean(impact, na.rm = TRUE),
              mean_land_ocean_temp_present = mean(mean_land_ocean_temp, na.rm = TRUE),
              mean_land_temp_present = mean(mean_land_temp, na.rm = TRUE))
  
  # calculate the mean natural disasters + global temp data
  #   from 1912 to 1942 the oldest 30 years
  past_30_years <-
    natural_disaster_data %>%
    filter(year >= 1912 & year <= 1942) %>%
    mutate(impact = (damage / 1000000000) / count) %>%
    group_by(disaster) %>%
    summarize(mean_count_past = mean(count, na.rm = TRUE),
              mean_damage_past = mean(damage, na.rm = TRUE),
              mean_impact_past = mean(impact, na.rm = TRUE),
              mean_land_ocean_temp_past = mean(mean_land_ocean_temp, na.rm = TRUE),
              mean_land_temp_past = mean(mean_land_temp, na.rm = TRUE))
  # join them together and calculate differences
  differences <-
    left_join(past_30_years,
              present_30_years,
              by = c("disaster")) %>%
    mutate(count_diff =
             mean_count_present - mean_count_past,
           damage_diff =
             (mean_damage_present - mean_damage_past)
           / 1000000000,
           impact_diff = 
             mean_impact_present - mean_impact_past,
           land_ocean_temp_diff =
             mean_land_ocean_temp_present - mean_land_ocean_temp_past,
           land_temp_diff =
             mean_land_temp_present - mean_land_temp_past) %>%
    select(disaster,
           count_diff,
           damage_diff,
           impact_diff,
           land_ocean_temp_diff,
           land_temp_diff) %>%
    arrange(-damage_diff)
  # rename columns
  colnames(differences) <-
    c("Disaster Type",
      "Difference in Count",
      "Difference in Economic Damage (billions of USD)",
      "Difference in Impact (billions of USD / count)",
      "Difference in Mean Land Temperature (˚C)",
      "Difference in Mean Land+Ocean Temperature (˚C)")
  
  return(differences)
}

