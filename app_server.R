library(shiny)

# import plotting functions
source("scripts/shiny_plots/total_temperature_heatmap.R")
# import data gathering functions
source("scripts/shiny_utils/data_gathering.R")

my_server <- function(input, output) {
  # gather all needed data here and pass to relevant functions
  # get DATASET 1 - average temperature per country on a monthly basis
  avg_country_temp_data <- get_avg_country_temp_data()
  
  # get heatmap of DATASET 1 using all recorded temperature with
  #   mega regions colored on along with clustering
  output$all_country_temp_heatmap <- renderPlot({
    all_country_temp_heatmap(avg_country_temp_data)
  })
}
