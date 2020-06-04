library(shiny)
library(plotly)

# import plotting functions
# page 1 plots
source("scripts/shiny_plots/total_temperature_heatmaps.R")
source("scripts/shiny_plots/emd_heatmap.R")
source("scripts/shiny_plots/group_world_maps.R")
source("scripts/shiny_plots/scatterplot_emd_groups.R")
# page 2 plots
source("scripts/shiny_plots/scatterplot_year_controlled.R")
# page 3 plots
source("scripts/shiny_plots/worldmap_temp_change.R")
# import summary information
source("scripts/shiny_plots/table_groups_summary.R")
# import data gathering functions
source("scripts/shiny_utils/data_gathering.R")
# import constants
source("scripts/shiny_utils/constants.R")
# also import nd_data
source("scripts/shiny_utils/constants_scatterplot.R")
# also imports avg_country_temp_data
source("scripts/shiny_utils/constants_worldmap.R")

my_server <- function(input, output) {
  # gather all needed data here and pass to relevant functions
  # get filtered DATASET 1 with mega regions
  mega_region_temp_data <- get_mega_region_temp_data(avg_country_temp_data)
  # precompute the correlation data for DATASET 1 temperature
  corr_temp_data_list <- get_cleaned_corr_temp_data(mega_region_temp_data)
  # precompute the correlation data for DATASET 1 emd
  corr_emd_data_list <- get_cleaned_corr_emd_data(mega_region_temp_data)

  # get corrmatrix of DATASET 1 using all recorded temperature with
  #   mega regions colored on along with clustering
  output$all_ct_temp_mega_corrmap <- renderPlot(
    all_country_temp_corrmap(corr_temp_data_list, "Mega Regions"),
    bg = background_color
  )

  # get corrmatrix of DATASET 1 using all recorded temperature with
  #   hclustered groups colored on along with clustering
  output$all_ct_temp_grouped_corrmap <- renderPlot(
    all_country_temp_corrmap(corr_temp_data_list, "Groups"),
    bg = background_color
  )

  # get world map for DATASET 1 and mega regions
  output$world_map_temp_mega_regions <- renderPlotly({
    plot <- world_map_groups(corr_temp_data_list, "Mega Regions",
                             "Correlation")
    plot
  })

  # get world map for DATASET 1 and hclustered groups
  output$world_map_temp_grouped <- renderPlotly({
    plot <- world_map_groups(corr_temp_data_list, "Groups",
                             "Correlation")
    plot
  })

  # get corrmatrix of DATASET 1 using all emds between 30 year ranges
  #   and a 70 year difference with mega regions
  output$all_ct_emd_mega_corrmap <- renderPlot(
    all_country_emd_corrmap(corr_emd_data_list, "Mega Regions"),
    bg = background_color
  )

  # get corrmatrix of DATASET 1 using all emds between 30 year ranges
  #   and a 70 year difference with mega regions with hclustered groups
  output$all_ct_emd_grouped_corrmap <- renderPlot(
    all_country_emd_corrmap(corr_emd_data_list, "Groups"),
    bg = background_color
  )

  # get world map for DATASET 1 and hclustered groups for emds
  output$world_map_emd_grouped <- renderPlotly({
    plot <- world_map_groups(corr_emd_data_list, "Groups",
                             "Wasserstein")
    plot
  })

  # get world map for DATASET 1 and hclustered groups for emds
  output$summary_emd_group_map <- renderPlotly({
    plot <- world_map_groups(corr_emd_data_list, "Groups",
                             "Wasserstein")
    plot
  })

  # get scatterplot of temp change by latitude for DATASET1
  #   with hclust groups colored on
  output$emd_grouped_scatterplot <- renderPlotly({
    plot <- scatterplot_emd_groups(corr_emd_data_list, "Groups",
                                   input$sp1_grouped_abs_lat_range,
                                   input$sp1_grouped_temp_range)
    plot
  })

  # get scatterplot of temp change by latitude for DATASET1
  #   with mega regions colored on
  output$emd_mega_scatterplot <- renderPlotly({
    plot <- scatterplot_emd_groups(corr_emd_data_list, "Mega Regions",
                                   input$sp1_mega_abs_lat_range,
                                   input$sp1_mega_temp_range)
    plot
  })

  # get scatter plot of disaster counts by year
  output$disaster_scatterplot <- renderPlotly({
    plot <- scatterplot_by_year(nd_data, input$disasters,
                                input$time_range)
    plot
  })

  # get world map for page 3 temperature changes
  output$temp_change_worldmap <- renderPlotly({
    plot <- temp_change_plot(avg_country_temp_data,
                             input$p3_2year_range)
    plot
  })

  # get table for summary latitude and change in temperature
  output$temp_change_summary_table <- renderText({
    table <- get_temp_summary_table(corr_emd_data_list)
    table
  })

  # get table for summary natural disaster counts
  output$nd_count_summary_table <- renderText({
    table <- get_nd_summary_table(nd_data,
                                  "count")
    table
  })

  # get table for summary natural disaster damages
  output$nd_damage_summary_table <- renderText({
    table <- get_nd_summary_table(nd_data,
                                  "damage")
    table
  })
}
