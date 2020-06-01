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
    HTML(wasserstein_earths),
    plotlyOutput(outputId = "world_map_emd_mega_regions"),
    plotOutput(outputId = "all_ct_emd_mega_corrmap"),
    plotlyOutput(outputId = "world_map_emd_grouped"),
    plotOutput(outputId = "all_ct_emd_grouped_corrmap")
  )
)
