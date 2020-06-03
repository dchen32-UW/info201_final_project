library(shiny)

# import overview page
source("overview.R")
# import page one : heatmaps and summary descriptions
source("page_one.R")
# import page two: scatter plot of disaster count by per year plot
source("page_two.R")
# import page three: world map with temperature change over range of years
source("page_three.R")

my_ui <- navbarPage(
  "Final Deliverable: Impacts of Climate Change",
  overview,
  page_one_heatmaps,
  page_two_scatterplot,
  page_three_worldmap
)
