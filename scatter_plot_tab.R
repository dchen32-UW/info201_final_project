library(shiny)
library(plotly)

disaster_df <- read.csv("data/kaggle_natural_disaster/number-of-natural-disaster-events.csv",
         stringsAsFactors = FALSE)

natural_disaster <- selectInput(
  inputId = "disaster_category",
  label = "Natural Disaster Category",
  choices = unique(disaster_df$Entity),
  selected = "All Natural Disasters"
)

slider_range <- range(disaster_df$Year)

year_slider <- sliderInput(
  inputId = "year_range",
  label = "Range of Years",
  min = slider_range[1],
  max = slider_range[2],
  value = slider_range
)

scatter_plot_tab <- tabPanel(
  "Disaster Count Per Year",
  titlePanel("Natural Disaster Count for Range of Years"),
  sidebarLayout(
    sidebarPanel(
      natural_disaster,
      year_slider
    ),
    mainPanel(
      plotOutput(outputId = "disaster_scatter_plot")
    )
  )
)
