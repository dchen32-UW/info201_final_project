library(ggplot2)
library(plotly)

# import relevant functions for the correlation matrices across all time
source("scripts/shiny_plots/total_temperature_heatmaps.R")
# import constants
source("scripts/shiny_utils/constants.R")

world_map_groups <- function(temp_data, anno_group) {
  # load in world map
  world_data <- map_data("world")
  # get list of groups and valid countries
  anno_df <- get_all_temp_corr_groups(temp_data, anno_group)
  countries <- row.names(anno_df$group_colors)
  # color in NA values specially
  num_groups <- length(anno_df$colors)
  anno_df$colors <- c(anno_df$colors, "grey")
  names(anno_df$colors) <- c(names(anno_df$colors)[1:num_groups],
                             "Not Considered")
  # isolate only one year and month in order to minimize the computation
  #   we know that February 1942 contains all countries so we isolate this
  #   instance and filter for valid countries that contain groups or mega regions
  temp_data_subset <-
    temp_data %>%
    filter(year == 1942) %>%
    filter(month == 2) %>%
    filter(region %in% countries) %>%
    mutate(map_groups = anno_df$group_colors[region, "groups"],
           map_colors = anno_df$group_colors[region, "colors"]) %>%
    select(region, map_groups, map_colors)
  # remove NA values
  temp_data_subset <- temp_data_subset[complete.cases(temp_data_subset), ]
  # join to world map lat and long data
  world_data_subset <- left_join(world_data, temp_data_subset, by = c("region"))
  # fill in NA groups with string NA
  world_data_subset[is.na(world_data_subset)] <- "Not Considered"
  # plot
  plot <-
    ggplot(data = world_data_subset) +
    geom_polygon(
      mapping = aes(x = long,
                    y = lat,
                    group = group,
                    fill = map_groups,
                    text = paste0("Country: ", region,
                                  "<br>",
                                  anno_group,  ": ", map_groups)),
      color = "white",
      size = .1
    ) +
    scale_fill_manual(values = anno_df$colors) +
    labs(fill = anno_group,
         title = paste(anno_group, "on World Map")) +
    blank_theme

  # make interactive
  plot <-
    ggplotly(plot, tooltip = "text") %>%
    layout(plot_bgcolor = background_color,
           paper_bgcolor = background_color,
           legend = list(bgcolor = background_color))

  return(plot)
}
