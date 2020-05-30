library(shiny)
library(shinyWidgets)

# import constants for background color
source("scripts/shiny_utils/constants.R")

# page one : country relationships and change of temperature
page_one <- tabPanel(
  "Temperature Change Across Time",
  titlePanel("Change in Mean Land Temperature Across Time 
             and Correlations Between Countries"),
  setBackgroundColor(
    color = background_color
  ),
  mainPanel(
    h3("Correlations Between Countries for All Recorded Temperatures"),
    p(
    paste0("In order to understand the relationships between the countries in
     our dataset 1, monthly mean land temperature per country, we compute and
     plot a correlation matrix of all of the countries in our dataset, along
     with their associated \"mega regions\" which are simply large combined
     groups of countries. We calculate this correlation matrix using all
     available time points and ", heatmap_corr_metric, "'s correlation metric.
     Furthermore, we utilize the R package hclust to group together similar
     countries and grouped the plotted correlation matrix based on such
     clustering. As geographically similar regions are likely to have similar
     temperatures across time we wanted to see whether we would see clustering
     of the \"mega regions\" so we also plotted each country's respective
     mega region as an annotation of the columns.")),
    plotOutput(outputId = "all_ct_temp_mega_corrmap"),
    p(paste0("As shown above, ")),
    plotOutput(outputId = "all_ct_temp_grouped_corrmap")
  )
)
