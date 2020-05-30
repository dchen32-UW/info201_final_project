library(transport)

# import constants
source("scripts/shiny_utils/constants.R")
# import plotting functions from previous plots
source("scripts/shiny_plots/total_temperature_heatmaps.R")

compute_hists <- function(temp_data, countries) {
  # set empty list for hists
  hists <- list()
  # gather hists for each country
  for (country in countries) {
    # get information for temps in the past
    past_temp_data <-
      temp_data %>%
      filter(year >= 1912 & year <= 1942) %>%
      filter(region == country) %>%
      select(avg_temp,
             date)
    # get information for temps in the present
    present_temp_data <-
      temp_data %>%
      filter(year >= 1982 & year <= 2012) %>%
      filter(region == country) %>%
      select(avg_temp,
             date)
    # calculate change
    avg_temp_past <-
      past_temp_data %>%
      pull(avg_temp)
    avg_temp_present <-
      present_temp_data %>%
      pull(avg_temp)
    change <-
      avg_temp_present - avg_temp_past
    
    # assign histogram, temp changes min=-10, max=10, and breaks every 0.25
    hists[[paste0(country)]] <- hist(change, xlim = c(-15, 15), breaks=seq(-15, 15, 0.125))$density
  }
  
  # combine into dataframe
  df_hists <- data.frame(hists)
  colnames(df_hists) <- countries

  return(df_hists)
}

compute_emds <- function(hists, countries) {
  # compute wasserstein distance matrix
  # create empty distance dataframe
  df_dist <- data.frame(row.names = countries)
  # compute distances, inefficient but it works
  for (country1 in countries) {
    distances <- c()
    for (country2 in countries) {
      distance <- wasserstein1d(hists[[country1]], hists[[country2]])
      distances <- c(distances, distance)
    }
    df_dist[country1] <- distances
  }

  return(df_dist)
}

all_country_emd_corrmap <- function(temp_data, anno_group) {
  # assign mega regions
  temp_data <-
    temp_data %>%
    mutate(
      mega_region =
        temp_data %>%
        pull(region) %>%
        countrycode("country.name",
                    "region")
    )
  # remove NA values, basically countries that did not match to continents
  temp_data <- temp_data[complete.cases(temp_data), ]

  # get unique countries
  countries <-
    temp_data %>%
    pull(region) %>%
    unique()

  # compute histograms for each 30 year range of 70 year change
  df_hist <- compute_hists(temp_data, countries)

  # compute wasserstein distance matrix
  df_dist <- compute_emds(hists, countries)

  # get color panel
  col <- colorRampPalette(c(heatmap_max, heatmap_middle, heatmap_min))(20)

  # compile into annotation dataframe
  annotations <- get_annotation_dataframe(temp_data, df_dist)
  
  # do clustering and assing groups based on dendrograms
  # get group annotations and colors
  if (anno_group == "Mega Regions") {
    group_annotations <- get_mega_regions(temp_data, annotations)
  } else if (anno_group == "Groups") {
    group_annotations <- get_group_regions(df_dist, annotations)
  }
  colors <- group_annotations$colors
  colsidecolors <- group_annotations$group_colors$colors

  # plot heatmap
  heatmap3(x = df_dist, col = col, symm = TRUE,
           ColSideColors = colsidecolors,
           ColSideLabs = anno_group,
           method = "ward.D2",
           legendfun = function()
             showLegend(legend = c(names(colors), "",
                                   "Small Distance",
                                   "Medium Distance",
                                   "Large Distance"),
                        col = c(colors,
                                background_color,
                                heatmap_max,
                                heatmap_middle,
                                heatmap_min),
                        cex = 0.75,
                        x = "top"))
}
