# import data gathering functions
source("scripts/shiny_utils/data_gathering.R")
# import function for scatterplot constant
source("scripts/shiny_plots/scatterplot_year_controlled.R")

# get DATASET 2 - integrated global temp, nd count + damage
nd_data <- get_nat_disaster_int_data()
# get outputs of nd data constants for DATASET2
nd_data_constants <- get_p2_scatterplot_constants(nd_data)
