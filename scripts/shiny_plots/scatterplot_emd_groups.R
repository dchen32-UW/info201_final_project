library(ggplot2)
library(plotly)
library(maps)

# import relevant functions for the correlation matrices
source("scripts/shiny_plots/total_temperature_heatmaps.R")
source("scripts/shiny_plots/emd_heatmap.R")
# import constants
source("scripts/shiny_utils/constants.R")

get_clean_merged_world_data <- function(data_list, anno_group) {
  # get temp_data
  temp_data <- data_list$temp_data
  # get list of groups and valid countries
  anno_df <- get_emd_changes_corr_groups(data_list, anno_group)
  # retrieve countries
  countries <- data_list$countries
  # load in world map
  world_data <-
    map_data("world") %>%
    filter(region %in% countries)
  # color in NA values specially
  num_groups <- length(anno_df$colors)
  anno_df$colors <- c(anno_df$colors, "grey")
  names(anno_df$colors) <- c(names(anno_df$colors)[1:num_groups],
                             "Not Considered")
  # isolate only one year and month in order to minimize the computation
  #   we know that February 1942 contains all countries so we isolate this
  #   instance and filter for valid countries that contain groups or
  #   mega regions
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

  # assign to list
  results <- list()
  results$anno_df <- anno_df
  results$world_data_subset <- world_data_subset

  return(results)
}

scatterplot_emd_groups <- function(data_list, anno_group,
                                   lat_range, temp_range) {
  # get cleaned data
  clean_data <- get_clean_merged_world_data(data_list, anno_group)
  # get world data subset
  world_data_subset <- clean_data$world_data_subset
  # get list of groups and valid countries
  anno_df <- clean_data$anno_df
  # retrieve means
  df_means <- data_list$df_means
  # get mean latitude per country
  world_data_subset <-
    world_data_subset %>%
    group_by(region) %>%
    summarise(map_groups = map_groups[1],
              map_colors = map_colors[1],
              mean_abs_lat = abs(mean(lat, na.rm = TRUE)),
              mean_long = mean(long, na.rm = TRUE)) %>%
    mutate(mean_temp_change = df_means[region, "mean_temp_change"])
  # filtering for widgets
  plot_data <-
    world_data_subset %>%
    filter(mean_abs_lat >= lat_range[1] &
             mean_abs_lat <= lat_range[2]) %>%
    filter(mean_temp_change >= temp_range[1] &
             mean_temp_change <= temp_range[2])
  # plot
  # deal with empty cases
  if (nrow(plot_data) == 0) {
    plot <-
      ggplot() +
      labs(color = anno_group,
           title = paste(anno_group,
                         "on ∆Temp by Abs Latitude"),
           x = "Absolute Latitude (Distance From Equator)",
           y = "Mean Land Temperature Change (˚C)")
    plot <-
      ggplotly(plot) %>%
      layout(plot_bgcolor = background_color,
             paper_bgcolor = background_color,
             legend = list(bgcolor = background_color))
  } else {
    plot <-
      ggplot(data = plot_data) +
      geom_point(
        mapping = aes(x = mean_abs_lat,
                      y = mean_temp_change,
                      color = map_groups,
                      text = paste0("Country: ", region,
                                    "<br>",
                                    anno_group,  ": ", map_groups,
                                    "<br>",
                                    "Mean Land Temp Change (˚C): ",
                                    round(mean_temp_change, 2),
                                    "<br>",
                                    "Absolute Latitude: ",
                                    round(mean_abs_lat, 2)))
      ) +
      scale_color_manual(values = anno_df$colors) +
      labs(color = anno_group,
           title = paste(anno_group,
                         "on ∆Temp by Abs Latitude"),
           x = "Absolute Latitude (Distance From Equator)",
           y = "Mean Land Temperature Change (˚C)")

    # make interactive
    plot <-
      ggplotly(plot, tooltip = "text") %>%
      layout(plot_bgcolor = background_color,
             paper_bgcolor = background_color,
             legend = list(bgcolor = background_color))
  }

  return(plot)
}
