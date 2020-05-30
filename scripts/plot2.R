library(ggplot2)
library(dplyr)

# PLOT 2 - plots a trendline of the counts of natural disaster
#   events, excluding all natural disasters, by year colored
#   by the type of natural disaster
# parameters:
#   - nd_data = dataframe of the natural disaster data including
#               year, count, and type of disaster
trendline_nd_count_by_year <- function(nd_data) {
  plot <-
    nd_data %>%
    ggplot() +
    geom_smooth(mapping = aes(x = year,
                              y = count,
                              color = disaster)) +
    labs(color = "Disaster Type",
         title = paste0("Disaster Count by Time ",
                        "with Associated Disaster Type"),
         x = "Time (year)",
         y = "Count (# of Occurrences)")
  return(plot)
}
<<<<<<< HEAD

=======
>>>>>>> fb5e62f1bc685e5c1399694db0500ee40f21606f
