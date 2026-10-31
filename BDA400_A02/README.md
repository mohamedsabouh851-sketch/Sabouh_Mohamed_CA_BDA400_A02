# BDA400 Assignment 2 — Preliminary Stage
Student: Sabouh Mohamed

## Requirements
R, RStudio, internet access; CRAN packages `quantmod` and `TTR` (the `zoo` dependency is installed with quantmod).

## Run
```r
install.packages(c("quantmod", "TTR"))
setwd("PATH/TO/THIS/FOLDER")
source("test_statistics.R")
source("run_analysis.R")
```

`run_analysis.R` reads `portfolio.txt`, retrieves Yahoo Finance price data, computes a 20-day moving average, mean, mode, median and sample standard deviation, prints tables and saves chart/CSV files under `output/`.

The code has not been executed in RStudio in this environment. Add actual screenshots from your R/RStudio installation and execution to the Word report before submitting.

Published repository: https://github.com/mohamedsabouh851-sketch/Sabouh_Mohamed_CA_BDA400_A02
