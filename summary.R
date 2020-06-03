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

# page layout
takeaways <- tabPanel(
  "Summary",
  titlePanel("Key Takeaways and Conclusion"),
  setBackgroundColor(
    color = background_color
  ),
  HTML(summary_para1),
  plotlyOutput(outputId = "summary_emd_group_map"),
  HTML(summary_para2),
  htmlOutput(outputId = "temp_change_summary_table")
)

# Take Away Two:

# One of our graph talks about natural disasters. It shows how the amount of 
# natural disasters have spiked over the years. What is cool about our graph
# is you an choose the year or type of natural disater so you can focus on
# certain ones or certain years. This is important to seeing the difference
# between years between natural disaters.


# Take Away Three:

# The last graph shows the change in temperature. What is cool about this is we
# added colors to it to show the difference in different countries and 
# years. This helps the viewer look more into it and better understand how
# the temperature has changed throughout the years.
# what is cool is you can pick a specific country and look at that one
# individually. Some countries have data farther back so it is interesting
# to go to different years and still see the changes throughout the years.
# Most data comes within the last 100 years so it is all fairly recent.