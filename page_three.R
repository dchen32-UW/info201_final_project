library(shiny)
library(plotly)

page_three_temp_change <- tabPanel(
  "Change in Temperature Between Years",
  sidebarLayout(
    sliderInput(
      inputId = "two_years_range",
      label = "Range of Years",
      #min = what dataset???,
      #max = what dataset???,
      #value = c(min, max)
    )
  ),
  mainPanel(
    plotlyOutput(outputId = "temp_change_worldmap")
  )
)