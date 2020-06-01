library(shiny)
library(plotly)

# import constants for scatterplot
source("scripts/shiny_utils/constants_scatterplot.R")

page_two_scatterplot <- tabPanel(
  "Disaster Count Per Year",
  titlePanel("Natural Disaster Count for Range of Years"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(inputId = "disasters",
                         label = "Natural Disaster Categories",
                         choices = nd_data_constants$checkbox_choices,
                         selected = nd_data_constants$checkbox_selected),
      sliderInput(
        inputId = "time_range",
        label = "Range of Years",
        sep = "",
        min = nd_data_constants$time_range$min,
        max = nd_data_constants$time_range$max,
        value = nd_data_constants$time_range$range
      )
    ),
    mainPanel(
      plotlyOutput(outputId = "disaster_scatterplot")
    )
  )
)
