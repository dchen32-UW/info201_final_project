library(ggplot2)
library(plotly)
library(dplyr)

#values for testing:
  #df <- avg_country_temp_data
  #years <- c(1850, 2000)

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
  
  #join the two year datasets and computer/include difference
  avg_temps_data <- full_join(data_yr1,
                              data_yr2,
                              by = "region") %>%
    mutate(change = (avg_temp_yr2 - avg_temp_yr1))

  #join previous temp dataset with world map
  map_data <- left_join(world_map, avg_temps_data)
  
  #make plot
  plot <- ggplot(map_data) +
    geom_polygon(mapping = aes(x = long,
                               y = lat,
                               group = group,
                               fill = change),
    )
  return(plot)
          
}
  
  #Theme
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
  #^just outting this here for now will change tomorrow^