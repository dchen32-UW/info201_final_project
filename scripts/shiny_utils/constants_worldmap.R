# import data gathering functions
source("scripts/shiny_utils/data_gathering.R")
# import function for scatterplot constant
source("scripts/shiny_plots/worldmap_year_controlled.R")

# get DATASET 1 - average temperature per country on a monthly basis
avg_country_temp_data <- get_avg_country_temp_data()
# get outputs of nd data constants for DATASET1
country_temp_constants <- get_p3_worldmap_constants(avg_country_temp_data)
