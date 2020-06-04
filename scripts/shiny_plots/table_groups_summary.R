library(RColorBrewer)
library(viridisLite)
library(kableExtra)
library(knitr)

# import relevant functions for the correlation matrices
source("scripts/shiny_plots/total_temperature_heatmaps.R")
source("scripts/shiny_plots/emd_heatmap.R")
# import cleaning functions
source("scripts/shiny_plots/scatterplot_emd_groups.R")
# import constants
source("scripts/shiny_utils/constants.R")

# gets summary table for natural disaster data for either
#   natural disaster count of economic damage in terms of
#   billions of USD
# parameters:
#   - nd_data : dataframe of integrated natural disaster count,
#               occurence, and global temperature in ˚C
#   - group : either "count" or "damage"
# returns:
#   - table : html table to render kable table
get_nd_summary_table <- function(nd_data, group) {
  # gather temperatures
  years <- c(1912, 1932, 1952, 1972, 1992, 2012)
  mean_land_temps <-
    nd_data %>%
    filter(disaster == "All natural disasters") %>%
    filter(year %in% years) %>%
    select(year, mean_land_temp)
  # color option
  option <- "D"
  # prep for quasiquotation
  group <- sym(group)
  # group 1962
  natdis <-
    nd_data %>%
    select(disaster, year, !!group) %>%
    filter(year %in% years) %>%
    mutate(year = as.character(year)) %>%
    spread(disaster, group) %>%
    rename(Year = year)
  # fill in NA values as 0
  natdis[is.na(natdis)] <- 0
  # differentially round damage
  if (group == "damage") {
    option <- "A"
    natdis <-
      natdis %>%
      mutate_if(is.numeric, function(x) round((x / 1e9), 2))
  }
  # set color parameters
  year_col <- colorRampPalette(c("black", "blue"))(6)
  # color tiles
  natdis_tbl <-
    natdis %>%
    mutate(mean_land_temp =
             mean_land_temps %>%
             filter(year == year) %>%
             pull(mean_land_temp) %>%
             round(1)) %>%
    mutate_if(is.character, function(x) {
      cell_spec(x, bold = T,
                color = "white",
                background = year_col,
                background_as_tile = T)
    }) %>%
    mutate_if(is.numeric, function(x) {
      cell_spec(x, bold = T,
                color = "white",
                background = spec_color(x, option = option, end = 0.8),
                background_as_tile = T,
                font_size = spec_font_size(x))
    })

  # rename columns
  colnames(natdis_tbl) <-
    c("Year", "All Natural Disasters", "Drought", "Earthquake",
      "Extreme Temperature", "Extreme Weather", "Flood",
      "Landslide", "Mass Movement (Dry)", "Wildfire",
      "Mean Land Temp (˚C)")

  # format into table
  table <-
    natdis_tbl %>%
    kable(escape = F) %>%
    kable_styling("hover", full_width = T)

  return(table)
}

# gets summary table for average country temperature data
#   for the Groups determined in page 1
# parameters:
#   - data_list : temperature data list containing groups,
#                 their relevant colors and temp_data
# returns:
#   - table : html table to render kable table
get_temp_summary_table <- function(data_list) {
  # get cleaned data
  clean_data <- get_clean_merged_world_data(data_list, "Groups")
  # get world data subset
  world_data_subset <- clean_data$world_data_subset
  # get list of groups and valid countries
  anno_df <- clean_data$anno_df
  # retrieve means
  df_means <- data_list$df_means
  # get mean latitude per map group
  world_data_subset <-
    world_data_subset %>%
    group_by(region) %>%
    summarise(map_groups = map_groups[1],
              map_colors = map_colors[1],
              mean_abs_lat = abs(mean(lat, na.rm = TRUE)),
              mean_long = mean(long, na.rm = TRUE)) %>%
    mutate(mean_temp_change = df_means[region, "mean_temp_change"]) %>%
    group_by(map_groups) %>%
    summarise(map_colors = map_colors[1],
              mean_abs_lat = mean(mean_abs_lat, na.rm = TRUE),
              mean_long = mean(mean_long, na.rm = TRUE),
              mean_temp_change = mean(mean_temp_change, na.rm = TRUE)) %>%
    select(map_groups, mean_abs_lat, mean_temp_change) %>%
    arrange(mean_abs_lat) %>%
    mutate(mean_abs_lat = round(mean_abs_lat, 2),
           mean_temp_change = round(mean_temp_change, 2))

  # get group colors
  groups <- world_data_subset %>% pull(map_groups)
  groups_colors <- anno_df$colors[groups]
  # format table
  bg_col <- colorRampPalette(c("yellow", "red"))(5)
  txt_col <- c("black", "black", "white", "white", "white")
  temp <-
    world_data_subset %>%
    mutate_at(vars(contains("group")), function(x) {
      cell_spec(x, bold = T,
                color = "black",
                background = groups_colors,
                background_as_tile = T)
    }) %>%
    mutate_if(is.numeric, function(x) {
      cell_spec(x, bold = T,
                color = txt_col,
                background = bg_col,
                background_as_tile = T,
                font_size = spec_font_size(x))
    })
  # rename columns
  colnames(temp) <-
    c("Group", "Mean |Latitude|", "Mean ∆Temp (˚C)")
  # get final table
  table <-
    temp %>%
    kable(escape = F) %>%
    kable_styling("hover", full_width = T)

  return(table)
}
