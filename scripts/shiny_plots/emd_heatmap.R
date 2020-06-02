library(transport)

# import constants
source("scripts/shiny_utils/constants.R")
# import plotting functions from previous plots
source("scripts/shiny_plots/total_temperature_heatmaps.R")

# computes a histogram for each country with the lowest change being -15,
#   the highest change being 15 and bins of 0.125, it computes the 70 year
#   difference in temperature for every month from 1982-2012, for example
#   one calculation is January 1982 - January 1912 this repeats till
#   Decemeber 2012 - December 1942, this helps to mitigate any yearly or
#   monthly variations in temperatures and reveals the general change in
#   temperature across time
# parameters:
#   - temp_data : dataframe of monthly avg land temperatures per country
#   - countries : list of countries in the dataset to look over
# returns:
#   - df_hists : dataframe of the histograms for each country
compute_hists <- function(temp_data, countries) {
  # set empty list for hists
  hists <- list()
  # set empty vector for mean changes in temperature
  means <- c()
  # gather hists for each country
  for (country in countries) {
    # get information for temps in the past
    past_temp_data <-
      temp_data %>%
      filter(year >= 1912 & year <= 1942) %>%
      filter(region == country) %>%
      select(avg_temp, date)
    # get information for temps in the present
    present_temp_data <-
      temp_data %>%
      filter(year >= 1982 & year <= 2012) %>%
      filter(region == country) %>%
      select(avg_temp, date)
    # calculate change
    avg_temp_past <-
      past_temp_data %>%
      pull(avg_temp)
    avg_temp_present <-
      present_temp_data %>%
      pull(avg_temp)
    change <-
      avg_temp_present - avg_temp_past
    # assign mean change
    means <- c(means, mean(change, na.rm = TRUE))
    # assign histogram, temp changes min=-10, max=10, and breaks every 0.25
    hists[[paste0(country)]] <- hist(change, xlim = c(-15, 15),
                                     breaks = seq(-15, 15, 0.125))$density
  }

  # combine into dataframe for hists
  df_hist <- data.frame(hists, stringsAsFactors = FALSE)
  colnames(df_hist) <- countries
  # combined into dataframe for means
  df_means <- data.frame(means, row.names = countries,
                         stringsAsFactors = FALSE)
  colnames(df_means) <- c("mean_temp_change")
  # assign in compact list
  results <- list()
  results$df_hist <- df_hist
  results$df_means <- df_means

  return(results)
}

# computes a distance matrix using EMD as the distance metric
#   between each countries distribution, we utilize a histogram of
#   70 year changes (31 years x 12 months = 372 measurments)
# parameters:
#   - hists : dataframe of the histograms for each country
#   - countries : list of countries in the dataset to look over
# returns:
#   - df_dist : EMD distance matrix between all countries in
#               countries parameter
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

# gets a clean data list containing a clean temperature dataframe
#   list of countries to look over, base annotation dataframe
#   and EMD distance matrix
# parameters:
#   - temp_data : dataframe of the monthly avg land temperatures per country
# returns:
#   - data_list : list of data needed to plot heatmap with EMD matrix
get_cleaned_corr_emd_data <- function(temp_data) {
  # create empty list to store data
  data_list <- list()
  # assign to data_list
  data_list$temp_data <- temp_data

  # get unique countries
  countries <-
    temp_data %>%
    pull(region) %>%
    unique()
  # assign to data_list
  data_list$countries <- countries

  # compute histograms for each 30 year range of 70 year change
  hist_results <- compute_hists(temp_data, countries)
  df_hist <- hist_results$df_hist
  df_means <- hist_results$df_means
  # assign to data_list
  data_list$df_hist <- df_hist
  data_list$df_means <- df_means

  # compute wasserstein distance matrix
  df_dist <- compute_emds(df_hist, countries)
  # assign to data_list
  data_list$df_dist <- df_dist

  # compile into annotation dataframe
  annotations <- get_annotation_dataframe(temp_data, df_dist)
  # assign to data_list
  data_list$annotations <- annotations

  return(data_list)
}

# gets a dataframe with the country name, group, and color
# parameters:
#  - data_list : list of data needed to calculate groups
#  - anno_group : group to gather data for, either Mega Regions or Groups
# returns:
#   - group annotations : dataframe with country name, group assignment,
#                         and color
get_emd_changes_corr_groups <- function(data_list, anno_group) {
  # get temp_data
  temp_data <- data_list$temp_data
  # get distance matrix
  df_dist <- data_list$df_dist
  # get annotations
  annotations <- data_list$annotations

  # do clustering and assing groups based on dendrograms
  # get group annotations and colors
  if (anno_group == "Mega Regions") {
    group_annotations <- get_mega_regions(temp_data, annotations)
  } else if (anno_group == "Groups") {
    group_annotations <- get_group_regions(df_dist, annotations)
  }

  return(group_annotations)
}

# plots a correlation matrix via a heatmap with the requested group
# parameters:
#  - data_list : list of data needed to calculate groups
#  - anno_group : group to gather data for, either Mega Regions or Groups
all_country_emd_corrmap <- function(data_list, anno_group) {
  # get temp_data
  temp_data <- data_list$temp_data
  # get distance matrix
  df_dist <- data_list$df_dist
  # get annotations
  annotations <- data_list$annotations

  # get color panel
  col <- colorRampPalette(c(heatmap_max, heatmap_middle, heatmap_min))(20)

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
