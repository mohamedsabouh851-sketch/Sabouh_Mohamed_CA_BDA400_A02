# BDA400 Assignment 2 — stock import and basic statistics
# Run from the directory containing portfolio.txt
# install.packages(c("quantmod", "TTR"))

load_stock_data <- function(portfolio_file = "portfolio.txt", from = "2023-01-01", to = Sys.Date()) {
  if (!requireNamespace("quantmod", quietly = TRUE)) stop("Install quantmod first")
  if (!file.exists(portfolio_file)) stop("Missing portfolio.txt")
  symbols <- unique(toupper(trimws(readLines(portfolio_file, warn = FALSE))))
  symbols <- symbols[nzchar(symbols)]
  if (!length(symbols)) stop("No symbols listed in portfolio.txt")
  output <- list()
  for (symbol in symbols) {
    if (!grepl("^[A-Z0-9.^_-]+$", symbol)) { warning("Invalid ticker: ", symbol); next }
    x <- tryCatch(quantmod::getSymbols(symbol, src = "yahoo", from = from, to = to, auto.assign = FALSE),
                  error = function(e) {warning(symbol, ": ", conditionMessage(e)); NULL})
    if (is.null(x) || NROW(x) == 0L) next
    dates <- as.Date(zoo::index(x))
    output[[symbol]] <- data.frame(Date = dates, Open = as.numeric(quantmod::Op(x)),
      High = as.numeric(quantmod::Hi(x)), Low = as.numeric(quantmod::Lo(x)),
      Close = as.numeric(quantmod::Cl(x)), Volume = as.numeric(quantmod::Vo(x)))
  }
  if (!length(output)) warning("No stock data could be retrieved. Check internet and tickers.")
  output
}

# Statistical mode here means the most common observed closing price.
# Floating-point prices may have many ties; the first such value is returned.
statistical_mode <- function(x) {
  x <- x[is.finite(x)]
  if (!length(x)) return(NA_real_)
  u <- unique(x)
  u[which.max(tabulate(match(x, u)))]
}

calculate_statistics <- function(stock_df, ma_period = 20L) {
  if (!all(c("Date", "Close") %in% names(stock_df))) stop("Expect Date and Close columns")
  prices <- as.numeric(stock_df$Close)
  prices <- prices[is.finite(prices)]
  if (!length(prices)) stop("No valid closing prices")
  if (length(ma_period) != 1L || ma_period < 1L || ma_period != as.integer(ma_period)) stop("Invalid MA period")
  moving_average <- if (length(prices) >= ma_period) mean(tail(prices, ma_period)) else NA_real_
  data.frame(Observations = length(prices), Mean = mean(prices),
     Mode = statistical_mode(prices), Median = median(prices),
     StandardDeviation = if(length(prices)>1) sd(prices) else NA_real_,
     LatestMovingAverage = moving_average, MA_Period = ma_period)
}

display_stock_data <- function(stocks, n = 6L) {
  for (symbol in names(stocks)) {
    cat("\n===", symbol, "===\n")
    print(utils::head(stocks[[symbol]], n))
    cat("Statistics:\n")
    print(calculate_statistics(stocks[[symbol]]))
  }
}
