library(shiny)
library(plotly)

# import constants
source("scripts/shiny_utils/constants.R")
# import constants for world map
source("scripts/shiny_utils/constants_worldmap.R")

# get HTML to write
main_panel_para_1 <-
  readChar("html/p3_para1.html",
           file.info("html/p3_para1.html")$size)
side_panel_para_1 <-
  readChar("html/p3_spara1.html",
           file.info("html/p3_spara1.html")$size)

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
        value = c(1912, 2012)
      ),
     HTML(side_panel_para_1)
    ),
    mainPanel(
      plotlyOutput(outputId = "temp_change_worldmap"),
      HTML(main_panel_para_1)
    )
  )
)
