# import data cleaning functions from shiny utils' R file
#   note this is a little different from the original one used
#   in the midpoint deliverables
source("scripts/shiny_utils/data_cleaning.R")

# gather the average country temperature data, on a monthly scale
#   using shiny utils' data cleaning functions
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
