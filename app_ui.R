library(shiny)

# import page one : heatmaps and summary descriptions
source("page_one.R")

my_ui <- navbarPage(
  "Final Deliverable [Also Maybe Project Title]",
  page_one
)
