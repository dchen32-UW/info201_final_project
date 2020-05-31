library(shiny)

# import page one : heatmaps and summary descriptions
source("page_one.R")
# import scatter plot: disaster count by per year plot
source("scatter_plot_tab.R")

my_ui <- navbarPage(
  "Final Deliverable [Also Maybe Project Title]",
  page_one,
  scatter_plot_tab
)
