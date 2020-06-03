library(shiny)
library(plotly)

# import constants
source("scripts/shiny_utils/constants.R")
# import constants for world map
source("scripts/shiny_utils/constants_worldmap.R")

page_three_worldmap <- tabPanel(
  "Change in Temperature Between Years",
  titlePanel("Mean Change in Global Temperatures for Range of Years"),
  setBackgroundColor(
    color = background_color
  ),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "p3_2year_range",
        label = "Range of Years",
        sep = "",
        min = country_temp_constants$time_range$min,
        max = country_temp_constants$time_range$max,
        value = country_temp_constants$time_range$range
      )
    ),
    mainPanel(
      plotlyOutput(outputId = "temp_change_worldmap")
    )
  )
)