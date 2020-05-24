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
    filter(disaster != "All natural disasters") %>%
    ggplot() +
      geom_smooth(mapping = aes(x = year,
                                y = count,
                                color = disaster))
  return(plot)
}

# PLOT 3 - plots a split by disaster type scatter plot of each
#   natural disaster, excluding all natural disasters, showing
#   count of natural disaster by average land temperature with
#   the damage the natural disasters for that year caused colored on
# parameters:
#   - nd_data = dataframe of the natural disaster data, combined with
#               the global land/land+ocean temperature per year dataframe
scatter_nd_count_by_temp <- function(nd_data) {
  plot <-
    nd_data %>%
    filter(disaster != "All natural disasters") %>%
    ggplot() +
      geom_point(mapping = aes(x = mean_land_temp,
                               y = count,
                               color = damage)) +
      facet_wrap(~disaster) +
      scale_color_gradientn(colours = rainbow(5))

  return(plot)
}
