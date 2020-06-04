library(shiny)
library(shinyWidgets)
library(plotly)

# import constants
source("scripts/shiny_utils/constants.R")

# load HTML paragraphs
summary_para1 <-
  readChar("html/summary_para1.html",
           file.info("html/summary_para1.html")$size)
summary_para2 <-
  readChar("html/summary_para2.html",
           file.info("html/summary_para2.html")$size)
summary_para3 <-
  readChar("html/summary_para3.html",
           file.info("html/summary_para3.html")$size)
summary_para4 <-
  readChar("html/summary_para4.html",
           file.info("html/summary_para4.html")$size)
summary_para5 <-
  readChar("html/summary_para5.html",
           file.info("html/summary_para5.html")$size)
summary_para6 <-
  readChar("html/summary_para6.html",
           file.info("html/summary_para6.html")$size)

# page layout
takeaways <- tabPanel(
  "Summary",
  titlePanel("Key Takeaways and Conclusion"),
  setBackgroundColor(
    color = background_color
  ),
  h4("Takeaway 1: Strong Correlation Between Latitude and ∆Temp"),
  HTML(summary_para1),
  plotlyOutput(outputId = "summary_emd_group_map"),
  HTML(summary_para2),
  htmlOutput(outputId = "temp_change_summary_table"),
  h4("Takeaway 2: Increase of Natural Disaster Over Time"),
  HTML(summary_para3),
  htmlOutput(outputId = "nd_count_summary_table"),
  HTML(summary_para4),
  htmlOutput(outputId = "nd_damage_summary_table"),
  HTML(summary_para5),
  h4("Takeaway 3: Increase of Temperature Over Time"),
  HTML(summary_para6)
)
