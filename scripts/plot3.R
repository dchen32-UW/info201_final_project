library(ggplot2)
library(dplyr)
guides
# PLOT 3 - plots a split by disaster type scatter plot of each
#   natural disaster, excluding "All Natural Disasters" group, showing
#   count of natural disaster by average land temperature with
#   the damage the natural disasters for that year caused colored on
# parameters:
#   - nd_data = dataframe of the natural disaster data, combined with
#               the global land/land+ocean temperature per year dataframe
scatter_nd_count_by_temp <- function(nd_data) {
  # transform damage to make better color scheme
  # transformation is 1 + x, to account for 0 values, then natural log
  #   to pull in large numbers
  nd_data <-
    nd_data %>%
    mutate(damage = log1p(damage / 1e11))
  # actual plot
  plot <-
    nd_data %>%
    ggplot() +
    geom_point(mapping = aes(x = mean_land_temp,
                             y = count,
                             color = damage)) +
    facet_wrap(~disaster,
               scales="free_y",
               nrow = 4) +
    scale_color_gradientn(colours = rainbow(5)) +
    labs(color = "Normalized Damage",
         title = paste0("Disaster Count by Mean Land Temperature ",
                        "with Associated Damage"),
         x = "Mean Land Temperature (˚C)",
         y = "Count (# of Occurrences)")
  
  return(plot)
}

