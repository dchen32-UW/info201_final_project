---
title: "INFO 201BB - Group 3"
author: "Daniel Chen, Grace Teebken, Tanner Lauzon, Kellen Maier"
date: "05/06/2020"
output: html_document
---

## Domain of Interest - **Climate Change**
We are interested in **Climate Change** because of its relevance to the world of today and tomorrow. How we choose to act against it will have major impact on the enviornment of the future as such, we are interested in how we can best utilize data to visualize its impacts and potential solutions.

Below we list a few examples of previous data driven projects relevant to **Climate Change**:

- [source 1](http://worrydream.com/ClimateChange/) - brief description
- [source 2](link 2) - brief description
- [source 3](link 3) - brief description

Based on our knowledge of **Climate Change** and the projects mentioned above, we propose the following questions:

- How is climate change impacting the ***economy*** of different countries, are there factors that make some countries more susceptible to having a larger carbon footprint?
    - By looking at both economy and climate data with a country by year dataset, we can overlay changes in economy and changes in climate, perhaps via a map with color map based on income/GDP and climate change factors. We can then examine the correlation between each variable from both an economy and climate dataset to examine what specific factors correlate the best with each other. This will allow us to see how the worsening climate impacts the global economy, if a positive relationship is found (worse climate correlate with worse economy) we can raise the stakes in the climate change discussion.
- How are ***natural disasters*** impacting or being impacted by climate change, how have their natural patterns/fluctuations change in accordance to the change in global environment?
    - We know that climate change is impacting the world, but exactly how and what it is doing is not particularly clear. As such we hope to integrate multiple datasets that cover different natural disasters, their frequency, and their impact and correlate that with climate change factors, such as change in temperature and sea level to examine possible correlation.
- What are the ***trackable by-products*** of climate change (e.g. CO2 emissions) and what factors correlate to such, as in are there risk factors involved?
    - By finding specific empirical measurments that correlate the best with climate change, we can hint at possible causual relationships and find better ways to empircally determine the level of climate change. We hope to examine the many measurments done on a country that could potentially impact the enviornment (e.g. CO2 emissions, energy production, etc.) and correlate that with the impacts of climate change, such as change in temp, to see which of these factors measured could be a potential risk factor (i.e. more negatively impact climate change).

## Finding Data
To help us to better understand this domain and answer the questions in the previous section we found the following datasets:

- [Temperature data with various scales](https://www.kaggle.com/berkeleyearth/climate-change-earth-surface-temperature-data)
    - This dataset is from kaggle, although the original raw data was gathered from [Berkely Earth data](http://berkeleyearth.org/data/). As the file is around ~500 MB we can not upload it to our GitHub as it is over the 50 MB upload size limit.
    - The data consists of five datasets:
        - Global Land and Ocean-and-Land Temperatures *(GlobalTemperatures.csv)*
            - Provides temperature measurments from 1750 onward for average land temperature and 1850 onward for average land + water temperature
            - Consists of nine columns:
                1. **dt** - date of measurment
                2. **LandAverageTemperature** - global average land temperature in celsius
                3. **LandAverageTemperatureUncertainty** - the 95% confidence interval around the average
                4. **LandMaxTemperature** - global average maximum land temperature in celsius
                5. **LandMaxTemperatureUncertainty** - the 95% confidence interval around the maximum land temperature
                6. **LandMinTemperature** - global average minimum land temperature in celsius
                7. **LandMinTemperatureUncertainty** - the 95% confidence interval around the minimum land temperature
                8. **LandAndOceanAverageTemperature** - global average land and ocean temperature in celsius
                9. **LandAndOceanAverageTemperatureUncertainty** - the 95% confidence interval around the global average land and ocean temperature
        - Global Average Land Temperature by Country *(GlobalLandTemperaturesByCountry.csv)*
        - Global Average Land Temperature by State *(GlobalLandTemperaturesByState.csv)*
        - Global Land Temperatures By Major City *(GlobalLandTemperaturesByMajorCity.csv)*
        - Global Land Temperatures By City *(GlobalLandTemperaturesByCity.csv)*
- [dataset 2](https://www.kaggle.com/dataenergy/natural-disaster-data#number-of-natural-disaster-events.csv)
- dataset 3




