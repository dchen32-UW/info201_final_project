library(shiny)
library(plotly)

page_three_temp_change <- tabPanel(
  "Change in Temperature Between Years",
  sidebarLayout(
    sliderInput(
      inputId = "two_years_range",
      label = "Range of Years",
      min = 0,
      max = 1,
      value = c(0, 1)
    ),
    mainPanel(
      plotlyOutput(outputId = "temp_change_worldmap")
    )
  )
)