source("scripts/shiny_plots/total_temperature_heatmap.R")
source("scripts/data_cleaning.R")

# DATASET 1
# gather average land temperature by country
avg_temp_by_country <-
  read.csv("data/kaggle_global_temp/GlobalLandTemperaturesByCountry.csv",
           stringsAsFactors = FALSE)

# DATASET 1
# get clean average temperature by country dataset
avg_country_temp_data <-
  get_clean_avg_country_temp(avg_temp_by_country)

all_country_temp_heatmap(avg_country_temp_data)
