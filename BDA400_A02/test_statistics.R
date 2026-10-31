source("stock_utilities.R")
x <- data.frame(Date = as.Date("2024-01-01") + 0:4, Close = c(2, 4, 4, 6, 9))
s <- calculate_statistics(x, ma_period = 3)
stopifnot(s$Observations == 5, s$Mean == 5, s$Mode == 4,
          s$Median == 4, abs(s$StandardDeviation - sd(x$Close)) < 1e-12,
          abs(s$LatestMovingAverage - mean(c(4,6,9))) < 1e-12)
cat("Basic statistics checks passed. Run the full import in RStudio separately.\n")
