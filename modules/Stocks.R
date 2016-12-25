library(quantmod)

# This Stock module provides basic functionality for retrieving basic stock
# data. It can retrieve the last price of the stock, the dividend yield,
# and the annual dividend payouts provided the symbol of the stock.
#
# In addition, this module can write stock information to a csv file provided
# the input csv file has a column labeled 'Symbol'.

# Get the last price of the stock
GetPrice <-  function(symbol)
{
    getQuote(symbol)[['Last']]
}

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

GetStock <- function(symbol)
{
    stock <- getQuote(symbol)
    stock[['Annual Dividend']] <- GetAnnualDividends(symbol)
    stock[['Dividend Yield']] <- GetDividendYield(symbol)

    stock
}
