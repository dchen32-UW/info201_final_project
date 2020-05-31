# import data cleaning functions from shiny utils' R file
#   note this is a little different from the original one used
#   in the midpoint deliverables
source("scripts/shiny_utils/data_cleaning.R")

# gather the average country temperature data, on a monthly scale
#   using shiny utils' data cleaning functions
# returns:
#   - temp_data : dataframe of the temperature measurments per country
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
