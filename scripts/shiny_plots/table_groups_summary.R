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


get_summary_table <- function(data_list) {
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
    mutate(mean_abs_lat = round(mean_abs_lat,),
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
