library(shiny)
library(plotly)

# import plotting functions
source("scripts/shiny_plots/total_temperature_heatmaps.R")
source("scripts/shiny_plots/total_temperature_world_map.R")
source("scripts/shiny_plots/emd_heatmap.R")
# import data gathering functions
source("scripts/shiny_utils/data_gathering.R")
# import constants for background color
source("scripts/shiny_utils/constants.R")

my_server <- function(input, output) {
  # gather all needed data here and pass to relevant functions
  # get DATASET 1 - average temperature per country on a monthly basis
  avg_country_temp_data <- get_avg_country_temp_data()
  
  # get corrmatrix of DATASET 1 using all recorded temperature with
  #   mega regions colored on along with clustering
  output$all_ct_temp_mega_corrmap <- renderPlot(
    all_country_temp_corrmap(avg_country_temp_data, "Mega Regions"),
    bg = background_color
  )

  # get corrmatrix of DATASET 1 using all recorded temperature with
  #   hclustered groups colored on along with clustering
  output$all_ct_temp_grouped_corrmap <- renderPlot(
    all_country_temp_corrmap(avg_country_temp_data, "Groups"),
    bg = background_color
  )

  # get world map for DATASET 1 and mega regions
  output$world_map_mega_regions <- renderPlotly({
    plot <- world_map_groups(avg_country_temp_data, "Mega Regions")
    plot
  })

  # get world map for DATASET 1 and hclustered groups
  output$world_map_grouped <- renderPlotly({
    plot <- world_map_groups(avg_country_temp_data, "Groups")
    plot
  })

  # get corrmatrix of DATASET 1 using all emds between 30 year ranges
  #   and a 70 year difference with mega regions
  output$all_ct_emd_mega_corrmap <- renderPlot(
    all_country_emd_corrmap(avg_country_temp_data, "Mega Regions"),
    bg = background_color
  )

  # get corrmatrix of DATASET 1 using all emds between 30 year ranges
  #   and a 70 year difference with mega regions with hclustered groups
  output$all_ct_emd_grouped_corrmap <- renderPlot(
    all_country_emd_corrmap(avg_country_temp_data, "Groups"),
    bg = background_color
  )
}
