# import data cleaning functions from shiny utils' R file
#   note this is a little different from the original one used
#   in the midpoint deliverables
source("scripts/shiny_utils/data_cleaning.R")

# gather the average country temperature data, on a monthly scale
#   using shiny utils' data cleaning functions
# returns:
#   - avg_country_temp_data : dataframe of the temp measurments per country
get_avg_country_temp_data <- function() {
  # DATASET 1
  # gather average land temperature by country
  avg_temp_by_country <-
    read.csv("data/kaggle_global_temp/GlobalLandTemperaturesByCountry.csv",
             stringsAsFactors = FALSE)

  # DATASET 1
  # get clean average temperature by country dataset
  avg_country_temp_data <-
    get_clean_avg_country_temp(avg_temp_by_country)

  return(avg_country_temp_data)
}

# gather the natural disaster and temperature combined data
#   using shiny utils' data cleaning functions
# returns:
#   - natural_disaster_data : dataframe of the integrated global mean land
#                             and land+ocean temperatures, natural disaster
#                             count and total economic damage data
get_nat_disaster_int_data <- function() {
  # DATASET 2
  # gather global temperature averages
  global_temp <-
    read.csv("data/kaggle_global_temp/GlobalTemperatures.csv",
             stringsAsFactors = FALSE)

  # gather natural disaster counts
  natural_disaster_count <-
    read.csv(paste0("data/kaggle_natural_disaster/number-of-natural",
                    "-disaster-events.csv"),
             stringsAsFactors = FALSE)

  # gather natural disaster USD damages
  natural_disaster_damage <-
    read.csv("data/kaggle_natural_disaster/damage-from-natural-disasters.csv",
             stringsAsFactors = FALSE)

  # DATASET 2
  # get clean combined natural disaster count, damage, and temp dataset
  natural_disaster_data <-
    get_clean_natural_disaster(global_temp,
                               natural_disaster_count,
                               natural_disaster_damage)

  return(natural_disaster_data)
}

# assign mega region to temp data and removes the rows that are NA
#   also known as countries that did not have a mega region
# parameters:
#   - temp_data : dataframe of the temperature measurments per country
# returns:
#   - temp_data : filtered input with mega regions column
get_mega_region_temp_data <- function(temp_data) {
  # assign mega regions
  temp_data <-
    temp_data %>%
    mutate(
      mega_region =
        temp_data %>%
        pull(region) %>%
        countrycode("country.name",
                    "region")
    )
  # remove NA values, basically countries that did not match to continents
  temp_data <- temp_data[complete.cases(temp_data), ]

  return(temp_data)
}
