library(quantmod)

# This Stock module provides basic functionality for retrieving basic stock
# data. It can retrieve the last price of the stock, the dividend yield,
# and the annual dividend payouts provided the symbol of the stock.
#
# In addition, this module can write stock information to a csv file provided
# the input csv file has a column labeled 'Symbol'.

# Get the price of the stock
GetPrice <- Vectorize(function(symbol)
{
    getQuote(symbol)[['Last']]
}, 'symbol')

# Get the dividend yield of the stock
GetDividendYield <- function(symbol)
{
    GetAnnualDividends(symbol) / GetPrice(symbol)
}

# Returns the annual dividends of the stock, or zero if the stock does not pay dividends
GetAnnualDividends <- Vectorize(function(symbol)
{
    dividends <- getDividends(symbol)
    dates <- format(as.Date(index(dividends)), format = '%Y')

    if (length(dates))
    {
        periods <- sum(dates == format(Sys.Date() - 365, '%Y'))
        dividend <- as.numeric(dividends[[length(dividends)]]) * periods
    }
    else
    {
        dividend <- 0
    }

    dividend
}, 'symbol')

# Update stock data. The input csv file must have a column labeled 'Symbol'.
# The output file is by default the same as the input file, unless the output
# file is specified.
UpdateStocks <- function(input, output = input)
{
    stock.list <- read.csv(input, stringsAsFactors = FALSE)
    stock.quotes <- getQuote(stock.list[['Symbol']])

    stock.quotes['Annual Dividend'] <- GetAnnualDividends(rownames(stock.quotes))
    stock.quotes['Dividend Yield'] <- stock.quotes['Annual Dividend'] / stock.quotes['Last']
    stock.quotes <- cbind(Symbol = rownames(stock.quotes), stock.quotes)

    write.csv(stock.quotes, file = output, row.names = FALSE)
}
