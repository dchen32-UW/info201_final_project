library(shiny)
library(plotly)

# page one : country relationships and change of temperature
page_one <- tabPanel(
  "Page One",
  titlePanel("Heatmap"),
  sidebarLayout(
    sidebarPanel(
      p("Hi there")
    ),
    mainPanel(
      plotOutput(outputId = "all_country_temp_heatmap")
    )
  )
)
