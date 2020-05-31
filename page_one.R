library(shiny)
library(shinyWidgets)
library(plotly)

# import constants
source("scripts/shiny_utils/constants.R")
# import text to write
main_panel_para_1 <-
  readChar("texts/p1_para1.txt", file.info("texts/p1_para1.txt")$size)
main_panel_para_2 <-
  readChar("texts/p1_para2.txt", file.info("texts/p1_para2.txt")$size)
main_panel_para_3 <-
  readChar("texts/p1_para3.txt", file.info("texts/p1_para3.txt")$size)
main_panel_para_4 <-
  readChar("texts/p1_para4.txt", file.info("texts/p1_para4.txt")$size)
main_panel_para_5 <-
  readChar("texts/p1_para5.txt", file.info("texts/p1_para5.txt")$size)

# get wasserstein images
wasserstein_earths <-
  readChar("html/wasserstein_earths.html",
           file.info("html/wasserstein_earths.html")$size)
# set title
title <-
  paste0("Change in Mean Land Temperature Across Time ",
         "and Correlations Between Countries")

# page one : country relationships and change of temperature
page_one <- tabPanel(
  "Temperature Change Across Time",
  titlePanel(title),
  setBackgroundColor(
    color = background_color
  ),
  mainPanel(
    h3("Correlations Between Countries for All Recorded Temperatures"),
    p(main_panel_para_1),
    plotlyOutput(outputId = "world_map_temp_mega_regions"),
    p(main_panel_para_2),
    plotOutput(outputId = "all_ct_temp_mega_corrmap"),
    p(main_panel_para_3),
    plotOutput(outputId = "all_ct_temp_grouped_corrmap"),
    plotlyOutput(outputId = "world_map_temp_grouped"),
    p(main_panel_para_4),
    hr(),
    p(main_panel_para_5),
    HTML(wasserstein_earths),
    plotlyOutput(outputId = "world_map_emd_mega_regions"),
    plotOutput(outputId = "all_ct_emd_mega_corrmap"),
    plotlyOutput(outputId = "world_map_emd_grouped"),
    plotOutput(outputId = "all_ct_emd_grouped_corrmap")
  )
)
