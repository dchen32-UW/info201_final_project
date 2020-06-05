library(ggplot2)
library(plotly)
library(dplyr)

# import constants (blank them)
source("scripts/shiny_utils/constants.R")

temp_change_plot <- function(df, years) {
  world_map <- map_data("world")

  #data for year 1
  data_yr1 <- df %>%
    filter(year == years[1]) %>%
    group_by(region) %>%
    summarise(avg_temp_yr1 = mean(avg_temp, na.rm = TRUE))

  #data for year 2
  data_yr2 <- df %>%
    filter(year == years[2]) %>%
    group_by(region) %>%
    summarise(avg_temp_yr2 = mean(avg_temp, na.rm = TRUE))

  #join the two year datasets and compute/include difference
  avg_temps_data <- full_join(data_yr1,
                              data_yr2,
                              by = "region") %>%
    mutate(change = (avg_temp_yr2 - avg_temp_yr1))

  #join previous temp dataset with world map
  map_data <- left_join(world_map, avg_temps_data)

  #make plot
  plot <-
    ggplot(map_data) +
    geom_polygon(
      mapping = aes(x = long,
                    y = lat,
                    group = group,
                    fill = change,
                    text =
                      paste0("Country: ", region,
                             "<br>",
                             "Change in Temp (˚C): ",
                             round(change, 2))),
      color = "white",
      size = .1
    ) +
    scale_fill_continuous(low = "Yellow", high = "Red") +
    labs(fill = "Mean Temp Change (˚C)",
         title =
         paste("Change in Mean Land Temperature from",
               years[1], "to", years[2])) +
    blank_theme

  # make interactive
  plot <-
    ggplotly(plot, tooltip = "text") %>%
    layout(plot_bgcolor = background_color,
           paper_bgcolor = background_color,
           legend = list(bgcolor = background_color))

  return(plot)
}
