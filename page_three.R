library(shiny)
library(plotly)

source("scripts/data_gathering.R")

min_year = min(avg_country_temp_data$year)
max_year = max(avg_country_temp_data$year)

page_three_worldmap <- tabPanel(
  "Change in Temperature Between Years",
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "two_years_range",
        label = "Range of Years",
        min = min_year,
        max = max_year,
        value = c(min_year, max_year)
      )
    ),
    mainPanel(
      plotlyOutput(outputId = "temp_change_worldmap")
    )
  )
)