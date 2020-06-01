library(ggplot2)
library(plotly)

# import plot constants
source("scripts/shiny_utils/constants.R")

# define constants for natural disaster data, while we could manually define
#   these in the constants.R file we calculate them here so we do not have to
#   repeat calculations twice which would be less efficient
# parameters:
#   - nd_data : dataframe of integrated
get_p2_scatterplot_constants <- function(nd_data) {
  # set empty list for constants
  constants <- list()
  # get checkbox choices
  checkbox_choices <-
    nd_data %>%
    pull(disaster) %>%
    unique()
  # assign unnamed to list
  constants$checkbox_selected <- checkbox_choices
  # name it to make labels
  names(checkbox_choices) <- checkbox_choices
  # assign to list
  constants$checkbox_choices <- checkbox_choices

  # get range of years
  time_range <-
    nd_data %>%
    pull(year) %>%
    range()
  # assign to list
  constants$time_range$min <- time_range[1]
  constants$time_range$max <- time_range[2]
  constants$time_range$range <- time_range

  return(constants)
}

# this stores nd_data_constants and will load it into page two upon import
nd_data_constants <- get_p2_scatterplot_constants(nd_data)

# plot an interactive scatterplot of the count of natural disasters by time
scatterplot_by_year <- function(nd_data, categories, time_range) {
  # filter data
  plot_data <-
    nd_data %>%
    filter(disaster %in% categories) %>%
    filter(year >= time_range[1] & year <= time_range[2])

  # deal with empty cases
  if (nrow(plot_data) == 0) {
    plot <-
      ggplot() +
      labs(color = "Disaster",
           title = "Count of Natural Disasters by Time",
           x = "Time (Year)",
           y = "Count (# of Occurences)")
    plot <-
      ggplotly(plot) %>%
      layout(plot_bgcolor = background_color,
             paper_bgcolor = background_color,
             legend = list(bgcolor = background_color))
  } else {
    # plot scatterplot
    plot <-
      plot_data %>%
      ggplot() +
      geom_point(
        mapping = aes(x = year,
                      y = count,
                      color = disaster,
                      text = paste0("Count: ", count,
                                    "<br>",
                                    "Disaster: ", disaster))
      ) +
      labs(color = "Disaster",
           title = "Count of Natural Disasters by Time",
           x = "Time (Year)",
           y = "Count (# of Occurences)")

    # make interactive
    plot <-
      ggplotly(plot, tooltip = "text") %>%
      layout(plot_bgcolor = background_color,
             paper_bgcolor = background_color,
             legend = list(bgcolor = background_color))
  }


  return(plot)
}
