library(shiny)
library(shinyWidgets)

# import constants for background color
source("scripts/shiny_utils/constants.R")

# page one : country relationships and change of temperature
page_one <- tabPanel(
  "Page One",
  titlePanel("Heatmap"),
  setBackgroundColor(
    color = background_color
  ),
  sidebarLayout(
    sidebarPanel(
      p("Hi there")
    ),
    mainPanel(
      plotOutput(outputId = "all_country_temp_heatmap")
    )
  )
)
