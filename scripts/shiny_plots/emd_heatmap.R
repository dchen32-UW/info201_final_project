# assign mega regions
glo_temp <-
  glo_temp %>%
  mutate(
    mega_region =
      glo_temp %>%
      pull(region) %>%
      countrycode("country.name",
                  "region")
  )
# remove NA values, basically countries that did not match to continents
glo_temp <- glo_temp[complete.cases(glo_temp), ]
# get information for yemen in the past
past_glo_temp <-
  glo_temp %>%
  filter(year >= 1912 & year <= 1942) %>%
  filter(region == "Yemen") %>%
  select(avg_temp,
         date)
# check dimensions
dim(past_glo_temp)
# get information for yemen in the present
present_glo_temp <-
  glo_temp %>%
  filter(year >= 1982 & year <= 2012) %>%
  filter(region == "Yemen") %>%
  select(avg_temp,
         date)
# check the dimensions
dim(present_glo_temp)
# calculate change
avg_temp_past <-
  past_glo_temp %>%
  pull(avg_temp)
avg_temp_present <-
  present_glo_temp %>%
  pull(avg_temp)
change <-
  avg_temp_present - avg_temp_past

yemen_change <- change
yemen_hist <- hist(yemen_change, xlim = c(-10, 10), breaks=-10:10)

russia_change <- change
russia_hist <- hist(russia_change, xlim = c(-10, 10), breaks=-10:10)
