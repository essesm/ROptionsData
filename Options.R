library(quantmod)
library(RQuantLib)
source('Stocks.R')

# This Options module provides basic functionality for retrieving option
# chains. It can also determine the option call or put closest to the provided
# delta for a given expiration. Basic cash flow and return information, like
# the discount, premium, and yield, can be retrieved.
#
# In addition, this module can write option information to a csv file provided
# the input csv file has a column labeled 'Symbol' and a column labeled
# 'Expiration'.

# Returns the option chain with Greeks (delta, gamma, vega, theta, and rho)
# The type must be either 'call' or 'put' and the expiration date must be a
# valid option expiration date.
GetOptionChain <- function(symbol, type, expiration.date)
{
    if (type == 'call')
    {
        option.chain <- getOptionChain(symbol, Exp = expiration.date)[['calls']]
    }
    else if (type == 'put')
    {
        option.chain <- getOptionChain(symbol, Exp = expiration.date)[['puts']]
    }

    # Calculate parameters to implied volatility function
    underlying <- GetPrice(symbol)
    dividend.yield <- GetDividendYield(symbol)
    risk.free.rate <- 0.05
    maturity <- (as.numeric(as.Date(expiration.date) - Sys.Date())) / 365

    # There is no way a put option can have a value less than the strike
    # minus the underlying. So this calculation adjusts the value.
    option.chain[['Ask']] <- ifelse(option.chain[['Strike']] - underlying > option.chain[['Ask']],
                  option.chain[['Strike']] - underlying + 0.01,
                  option.chain[['Ask']])

    print(symbol)
    # Use the following three lines to debug when the
    # implied volatility cannot be calculated correctly.
    # option.chain <- head(option.chain)
    # print(GetPrice(symbol))
    # print(option.chain)

    EuropeanOptionImpliedVolatility <- Vectorize(EuropeanOptionImpliedVolatility, c('value', 'strike'))
    option.chain['Implied Volatility'] <- EuropeanOptionImpliedVolatility(
                            type = type,
                            value = option.chain[['Ask']],
                            underlying = underlying,
                            strike = option.chain[['Strike']],
                            dividendYield = dividend.yield,
                            riskFreeRate = risk.free.rate,
                            maturity = maturity,
                            volatility = 0.01)

    EuropeanOption <- Vectorize(EuropeanOption, c('strike', 'volatility'))
    greeks <- EuropeanOption(
                type = type,
                underlying = underlying,
                strike = option.chain[['Strike']],
                dividendYield = dividend.yield,
                riskFreeRate = risk.free.rate,
                maturity = maturity,
                volatility = option.chain[['Implied Volatility']])

    option.chain[['Delta']] <- unlist(greeks['delta',])
    option.chain[['Gamma']] <- unlist(greeks['gamma',])
    option.chain[['Vega']] <- unlist(greeks['vega',])
    option.chain[['Theta']] <- unlist(greeks['theta',])
    option.chain[['Rho']] <- unlist(greeks['rho',])

    option.chain
}

# Returns the option closest to the delta provided. The type must be either
# 'call' or 'put' and the expiration date must be a valid option expiration.
# Deltas for call options are always between zero and one and deltas for put
# options are always between zero and negative one.
GetOption <- Vectorize(function(symbol, type, expiration.date, delta)
{
    option.chain <- GetOptionChain(symbol, type, expiration.date)

    option.chain[['Delta Diff']] <- abs(unlist(option.chain[['Delta']]) - delta)
    option.chain <- option.chain[order(option.chain[['Delta Diff']]),]
    option.chain[['Delta Diff']] <- NULL
    option.chain <- cbind(Symbol = symbol,
                          Expiration = expiration.date,
                          `Days Until Expiration` = as.numeric(as.Date(expiration.date) - Sys.Date()),
                          option.chain,
                          stringsAsFactors = FALSE)


    option.chain[1,]
}, c("symbol", "expiration.date"))

# Update option data. This will output the put options with a delta closest to
# -0.25. The input csv file must have a column labeled 'Symbol' and a column
# labeled 'Expiration'. The output file is by default the same as the input
# file, unless the output file is specified.
UpdateOptions <- function(input, output = input)
{
    options <- read.csv(input, stringsAsFactors = FALSE)
    options <- GetOption(t(options['Symbol']), 'put', t(options['Expiration']), -0.25)

    # Calculate statistics like discount, premium, and yield
    discount <- 1 - unlist(options['Strike',]) / unlist(GetPrice(options['Symbol',]))
    premium <- 100 * (unlist(options['Bid',]) + unlist(options['Ask',]))/2
    yield <- premium / (unlist(options['Strike',]) * 100) * 365 / unlist(options['Days Until Expiration',])

    options <- rbind(options, Discount = discount, Premium = premium, Yield = yield)

    write.csv(t(options), file = output, row.names = FALSE)
}
