library(ggplot2)
library(dplyr)

# PLOT 1 - plots a world map of the change in temperature from
#   1912 to 2012, positive means a growth in temperature,
#   negative means a decrease in temperature
# parameters:
#   - glo_temp = dataframe of the global temperature data including
#                year, mean land and mean land+ocean temperatures
world_map_temp_change <- function(glo_temp) {
  # load in world map
  world_data <- map_data("world")
  # define minimalistic theme
  blank_theme <- theme_bw() + 
    theme(
      axis.line = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      plot.background = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
    )
  # filter for 1912 data
  subset_1912 <-
    glo_temp %>%
    filter(year == 1912) %>%
    group_by(region) %>%
    summarize(avg_temp_1912 = mean(avg_temp, na.rm = TRUE))
  # filter for 2012 data
  subset_2012 <-
    glo_temp %>%
    filter(year == 2012) %>%
    group_by(region) %>%
    summarize(avg_temp_2012 = mean(avg_temp, na.rm = TRUE))
  # join them together
  subset <- inner_join(subset_2012,
                       subset_1912,
                       by = "region")
  # compute change
  subset <-
    subset %>%
    mutate(temp_change = avg_temp_2012 - avg_temp_1912)
  # clean it up, remove any possible NA values
  subset <- subset[complete.cases(subset), ]
  # join to world map lat and long data
  world_data_subset <- left_join(world_data, subset)
  plot <-
    ggplot(data = world_data_subset) + 
    geom_polygon(
      mapping = aes(x = long,
                    y = lat,
                    group = group,
                    fill = temp_change),
      color = "white",
      size = .1
    ) + 
    scale_fill_continuous(low = "Yellow", high = "Red") + 
    labs(fill = "Avg Temp Change (˚C)",
         title = "Change in Average Temperature from 1912 to 2012") + 
    blank_theme
  return(plot)
}