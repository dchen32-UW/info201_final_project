library(shiny)
library(shinyWidgets)

# import constants
source("scripts/shiny_utils/constants.R")

#load HTML paragraphs
overview_para1 <-
  readChar("html/overview_para1.html",
           file.info("html/overview_para1.html")$size)
overview_para2 <-
  readChar("html/overview_para2.html",
           file.info("html/overview_para2.html")$size)
overview_para3 <-
  readChar("html/overview_para3.html",
           file.info("html/overview_para3.html")$size)

#page layout
overview <- tabPanel(
  "Overview",
  titlePanel("Climate Change Impacts on Temperature and Natural Disasters"),
  setBackgroundColor(
    color = background_color
  ),
  HTML(overview_para1),
  img(alt = "Bangladesh Floods", src = "floods.jpg"),
  HTML(overview_para2),
  HTML(overview_para3)
)
