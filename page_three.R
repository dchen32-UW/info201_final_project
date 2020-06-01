library(shiny)
library(plotly)

source("scripts/shiny_utils/constants_worldmap.R")

page_three_worldmap <- tabPanel(
  "Change in Temperature Between Years",
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "two_years_range",
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