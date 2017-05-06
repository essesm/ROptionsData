library(quantmod)
library(RQuantLib)
source('../modules/Stocks.R')

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
    else
    {
        stop(paste('invalid option type: ', type, ', use \'put\' or \'call\''))
    }

    days.until.expiration <- as.numeric(expiration.date - Sys.Date())
    option.chain <- cbind(Symbol = symbol,
                          Option = row.names(option.chain),
                          Expiration = format(expiration.date, '%m-%d-%Y'),
                          `Days Until Expiration` = days.until.expiration,
                          option.chain,
                          stringsAsFactors = FALSE)

    # Calculate parameters to implied volatility function
    underlying <- GetPrice(symbol)
    dividend.yield <- GetDividendYield(symbol)
    risk.free.rate <- 0.05
    maturity <- days.until.expiration / 365
    volatility = 0.01

    # There is no way a put option can have a value less than the strike
    # minus the underlying, but sometimes the source used in getOptionChain
    # is not up to date. This calculation adjusts the Ask so implied volatility
    # calculations are possible.
    option.chain['Ask'] <- ifelse(option.chain[['Strike']] - underlying > option.chain[['Ask']],
                  option.chain[['Strike']] - underlying + 0.01,
                  option.chain[['Ask']])

    option.chain['Discount'] <- 1 - option.chain['Strike'] / GetPrice(symbol)
    option.chain['Premium'] <- 100 * (option.chain['Bid'] + option.chain['Ask']) / 2
    option.chain['Yield'] <- option.chain['Premium'] / (option.chain['Strike'] * 100) * 365 / option.chain['Days Until Expiration']

    EuropeanOptionImpliedVolatility <- Vectorize(EuropeanOptionImpliedVolatility, c('value', 'strike'))
    option.chain['Implied Volatility'] <- EuropeanOptionImpliedVolatility(
                            type = type,
                            value = option.chain[['Ask']],
                            underlying = underlying,
                            strike = option.chain[['Strike']],
                            dividendYield = dividend.yield,
                            riskFreeRate = risk.free.rate,
                            maturity = maturity,
                            volatility = volatility)

    EuropeanOption <- Vectorize(EuropeanOption, c('strike', 'volatility'))
    greeks <- EuropeanOption(
                type = type,
                underlying = underlying,
                strike = option.chain[['Strike']],
                dividendYield = dividend.yield,
                riskFreeRate = risk.free.rate,
                maturity = maturity,
                volatility = option.chain[['Implied Volatility']])

    option.chain['Delta'] <- unlist(greeks['delta',])
    option.chain['Gamma'] <- unlist(greeks['gamma',])
    option.chain['Vega'] <- unlist(greeks['vega',])
    option.chain['Theta'] <- unlist(greeks['theta',])
    option.chain['Rho'] <- unlist(greeks['rho',])

    option.chain
}

# Returns the option closest to the value provided for the given key. The key
# is case sensitive. For example, if you want the option with the put closest
# to a Delta equal to -0.25, set key = 'Delta' and value = -0.25.
GetOption <- function(symbol, type, expiration.date, key, value)
{
    option.chain <- GetOptionChain(symbol, type, expiration.date)

    option.chain['Diff'] <- abs(option.chain[[key]] - value)
    option.chain <- option.chain[order(option.chain[['Diff']]),]
    option.chain['Diff'] <- NULL

    option.chain[1,]
}
