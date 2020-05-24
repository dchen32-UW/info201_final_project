library(dplyr)

# DATASET SPECIFIC CLEANING FUNCTIONS
# cleans kaggle specific natural disaster type data
# parameters:
#   - nd_data = dataframe of kaggle's natural disaster data
clean_kaggle_nd_data <- function(nd_data, type) {
  # remove "Code" column
  nd_data <- select(nd_data, -"Code")
  # rename columns
  if (type == "econ") {
    colnames(nd_data) <- c("disaster", "year", "damage")
  } else {
    colnames(nd_data) <- c("disaster", "year", "count")
  }
  # remove any rows with NA
  nd_data <- nd_data[complete.cases(nd_data), ]
  
  return(nd_data)
}

# cleans kaggle specific global temperature data
# parameters:
#   - glo_temp_data = dataframe of kaggle's global temperature data
clean_kaggle_glo_temp_data <- function(glo_temp_data) {
  # select for relevant data
  glo_temp_data <-
    glo_temp_data %>%
    select(dt,
           LandAverageTemperature,
           LandAndOceanAverageTemperature)
  # remove any rows with NA
  glo_temp_data <- glo_temp_data[complete.cases(glo_temp_data), ]
  # get year column
  glo_temp_data <-
    glo_temp_data %>%
    mutate(year = as.integer(substring(dt, 1, 4)))
  # gather by year data (as original data is in weird time arrangement)
  glo_temp_data <-
    glo_temp_data %>%
    group_by(year) %>%
    summarize(mean_land_ocean_temp =
                mean(LandAndOceanAverageTemperature,
                     na.rm = TRUE),
              mean_land_temp =
                mean(LandAverageTemperature,
                     na.rm = TRUE))
  # remove any rows with NA, just to make sure
  glo_temp_data <- glo_temp_data[complete.cases(glo_temp_data), ]
  
  return(glo_temp_data)
}

# FINAL MERGING AND CLEANING FUNCTIONS
# combines and cleans global temperature data, count and damage of
#   natural disasters
# parameters:
#   - glo_temp = dataframe of global temperature data
#   - nd_count = dataframe of count of natural disaster eventsa
#   - nd_econ = dataframe of damage of natural disasters events in USD
get_clean_natural_disaster <- function(glo_temp, nd_count, nd_econ) {
  # clean up natural disaster count dataframe
  nd_count <- clean_kaggle_nd_data(nd_count, "count")
  # clean up natural disaster damage dataframe
  nd_econ <- clean_kaggle_nd_data(nd_econ, "econ")
  # clean up global temp data
  glo_temp <- clean_kaggle_glo_temp_data(glo_temp)
  # merge data
  # merge natural disaster data together
  result <- left_join(nd_econ,
                      nd_count,
                      by = c("year", "disaster"))
  # merge combined natural disaster with global temp data
  result <- left_join(result,
                      glo_temp,
                      by = c("year"))
  # clean up any new NA values
  result <- result[complete.cases(result), ]
  
  return(result)
}

# cleans temperature by country data
# parameters:
#   - country_temp = dataframe of country temperature data
get_clean_avg_country_temp <- function(country_temp) {
  # add year and month
  country_temp <-
    country_temp %>%
    mutate(year = as.integer(substring(dt, 1, 4)))
  country_temp <-
    country_temp %>%
    mutate(month = as.integer(substring(dt, 6, 7)))
  # rename columns to more appropiate names
  colnames(country_temp) <-
    c("date", "avg_temp", "avg_temp_se", "region", "year", "month")
  # rename countries to match ggplot map data
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Bosnia And Herzegovina",
                           "Bosnia and Herzegovina", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "British Virgin Islands",
                           "Virgin Islands", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Burma", "Myanmar", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Côte D'Ivoire", "Ivory Coast", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Congo (Democratic Republic Of The)",
                           "Democratic Republic of the Congo", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Congo", "Republic of Congo", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Curaçao", "Curacao", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Falkland Islands (Islas Malvinas)",
                           "Falkland Islands", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Federated States Of Micronesia",
                           "Micronesia", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Guinea Bissau", "Guinea-Bissau", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Heard Island And Mcdonald Islands",
                           "Heard Island", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Isle Of Man", "Isle of Man", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Palestina", "Palestine", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Saint Barthélemy",
                           "Saint Barthelemy", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Saint Pierre And Miquelon",
                           "Saint Pierre and Miquelon", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Sao Tome And Principe",
                           "Sao Tome and Principe", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Timor Leste", "Timor-Leste", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "Turks And Caicas Islands",
                           "Turks and Caicos Islands", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "United States", "USA", region))
  country_temp <-
    country_temp %>%
    mutate(region = ifelse(region == "United Kingdom", "UK", region))
  # remove any NA values
  country_temp <- country_temp[complete.cases(country_temp), ]
  
  return(country_temp)
}
