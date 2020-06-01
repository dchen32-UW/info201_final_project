library(ggplot2)
library(plotly)

# import plot constants
source("scripts/shiny_utils/constants.R")

# define constants for monthly temperature data, while we could manually define
#   these in the constants.R file we calculate them here so we do not have to
#   repeat calculations twice which would be less efficient
# parameters:
#   - temp_data : dataframe of monthly mean land temperatures per country
get_p3_worldmap_constants <- function(temp_data) {
  # set empty list for constants
  constants <- list()
  # get range of years
  time_range <-
    temp_data %>%
    pull(year) %>%
    range()
  # assign to list
  constants$time_range$min <- time_range[1]
  constants$time_range$max <- time_range[2]
  constants$time_range$range <- time_range
  
  return(constants)
}