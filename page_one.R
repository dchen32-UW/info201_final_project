library(shiny)
library(shinyWidgets)
library(plotly)

# import constants
source("scripts/shiny_utils/constants.R")

# get HTML to write
main_panel_para_1 <-
  readChar("html/p1_para1.html",
           file.info("html/p1_para1.html")$size)
main_panel_para_2 <-
  readChar("html/p1_para2.html",
           file.info("html/p1_para2.html")$size)
main_panel_para_3 <-
  readChar("html/p1_para3.html",
           file.info("html/p1_para3.html")$size)
main_panel_para_4 <-
  readChar("html/p1_para4.html",
           file.info("html/p1_para4.html")$size)
main_panel_para_5 <-
  readChar("html/p1_para5.html",
           file.info("html/p1_para5.html")$size)
main_panel_para_6 <-
  readChar("html/p1_para6.html",
           file.info("html/p1_para6.html")$size)
main_panel_para_7 <-
  readChar("html/p1_para7.html",
           file.info("html/p1_para7.html")$size)
main_panel_para_8 <-
  readChar("html/p1_para8.html",
           file.info("html/p1_para8.html")$size)
main_panel_para_9 <-
  readChar("html/p1_para9.html",
           file.info("html/p1_para9.html")$size)
main_panel_para_10 <-
  readChar("html/p1_para10.html",
           file.info("html/p1_para10.html")$size)
wasserstein_earths <-
  readChar("html/wasserstein_earths.html",
           file.info("html/wasserstein_earths.html")$size)
# set title
title <-
  paste0("Change in Mean Land Temperature Across Time ",
         "and Correlations Between Countries")

# page one : country relationships and change of temperature
page_one_heatmaps <- tabPanel(
  "Temperature Change Across Time",
  titlePanel(title),
  setBackgroundColor(
    color = background_color
  ),
  mainPanel(
    h3("Correlations Between Countries for All Recorded Temperatures"),
    HTML(main_panel_para_1),
    plotlyOutput(outputId = "world_map_temp_mega_regions"),
    HTML(main_panel_para_2),
    plotOutput(outputId = "all_ct_temp_mega_corrmap"),
    HTML(main_panel_para_3),
    plotOutput(outputId = "all_ct_temp_grouped_corrmap"),
    HTML(main_panel_para_4),
    plotlyOutput(outputId = "world_map_temp_grouped"),
    HTML(main_panel_para_5),
    hr(),
    h3(paste("EMD Distance Between Countries for Changes",
             "in Monthly Temperature Recordings")),
    HTML(main_panel_para_6),
    HTML(wasserstein_earths),
    HTML(main_panel_para_7),
    plotOutput(outputId = "all_ct_emd_mega_corrmap"),
    HTML(main_panel_para_8),
    plotOutput(outputId = "all_ct_emd_grouped_corrmap"),
    HTML(main_panel_para_9),
    plotlyOutput(outputId = "world_map_emd_grouped"),
    HTML(main_panel_para_10),
    sliderInput(
      inputId = "sp1_grouped_abs_lat_range",
      label = "Range of Absolute Latitude",
      sep = "",
      min = splot_p1_abs_lat_range$min,
      max = splot_p1_abs_lat_range$max,
      value = splot_p1_abs_lat_range$range
    ),
    sliderInput(
      inputId = "sp1_grouped_temp_range",
      label = "Range of Temp Change (˚C)",
      sep = "",
      min = splot_p1_temp_range$min,
      max = splot_p1_temp_range$max,
      value = splot_p1_temp_range$range
    ),
    plotlyOutput(outputId = "emd_grouped_scatterplot"),
    sliderInput(
      inputId = "sp1_mega_abs_lat_range",
      label = "Range of Absolute Latitude",
      sep = "",
      min = splot_p1_abs_lat_range$min,
      max = splot_p1_abs_lat_range$max,
      value = splot_p1_abs_lat_range$range
    ),
    sliderInput(
      inputId = "sp1_mega_temp_range",
      label = "Range of Temp Change (˚C)",
      sep = "",
      min = splot_p1_temp_range$min,
      max = splot_p1_temp_range$max,
      value = splot_p1_temp_range$range
    ),
    plotlyOutput(outputId = "emd_mega_scatterplot")
  )
)
