library(shiny)

# import page one : heatmaps and summary descriptions
source("page_one.R")
# import page two: scatter plot of disaster count by per year plot
source("page_two.R")
# import page three: plotted temperature change on the world map
source("page_three.R")

my_ui <- navbarPage(
  "Final Deliverable: Impacts of Climate Change",
  page_one_heatmaps,
  page_two_scatterplot
)
