library(ggplot2)

# define background color
background_color <- "#ebebeb"
# define min, middle, and max colors for heatmaps
# google search of "matplotlib colors" gives available colors
heatmap_min <- "blue"
heatmap_middle <- "greenyellow"
heatmap_max <- "red"
# define correlation metric for heatmaps
# choose from spearman and pearson
heatmap_corr_metric <- "spearman"
# define plot constants blank theme for maps
# define minimalistic theme
blank_theme <- theme_bw() +
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    plot.background = element_rect(fill = background_color,
                                   color = background_color),
    legend.background = element_rect(fill = background_color,
                                     color = background_color),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
  )
# define min and max for scatterplot on page 1
splot_p1_abs_lat_range <- list(min = 0, max = 75, range = c(0, 75))
splot_p1_temp_range <- list(min = 0, max = 1.5, range = c(0, 1.5))
