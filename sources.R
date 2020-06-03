library(shiny)
library(shinyWidgets)

# import constants
source("scripts/shiny_utils/constants.R")

# load HTML paragraphs
sources_para1 <-
  readChar("html/sources_para1.html",
           file.info("html/sources_para1.html")$size)

# page layout
sources <- tabPanel(
  "Sources",
  titlePanel(""),
  setBackgroundColor(
    color = background_color
  ),
  HTML(sources_para1)
)