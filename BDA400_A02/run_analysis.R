# Execute in RStudio from this folder. Requires internet for Yahoo Finance.
source("stock_utilities.R")
stocks <- load_stock_data("portfolio.txt", from = "2023-01-01", to = Sys.Date())
if (!length(stocks)) stop("No stocks loaded. Check connection, ticker, and Yahoo Finance.")
display_stock_data(stocks)
if (!dir.exists("output")) dir.create("output")
summary_rows <- lapply(names(stocks), function(s) cbind(Symbol = s, calculate_statistics(stocks[[s]])))
write.csv(do.call(rbind, summary_rows), "output/stock_statistics.csv", row.names = FALSE)
for (symbol in names(stocks)) {
  d <- stocks[[symbol]]
  write.csv(d, file.path("output", paste0(symbol, "_prices.csv")), row.names = FALSE)
  png(file.path("output", paste0(symbol, "_close.png")), width = 1000, height = 620)
  plot(d$Date, d$Close, type = "l", col = "navy", lwd = 2,
       main = paste(symbol, "Closing Prices"), xlab = "Date", ylab = "Price (USD)")
  if (nrow(d) >= 20) {
    moving <- as.numeric(stats::filter(d$Close, rep(1/20, 20), sides = 1))
    lines(d$Date, moving, col = "orange", lwd = 2)
    legend("topleft", legend = c("Close", "20-day SMA"), col = c("navy", "orange"), lty = 1, bty = "n")
  }
  dev.off()
}
cat("Finished. Inspect output/ for CSV and PNG files.\n")
