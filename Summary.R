# This Summary module is meant to provide the functionality to take in a csv
# file that strike prices, premiums, and values of stocks and append a column
# that shows the cash flow. For example, if the value of the strike price
# column is greater than the value of the stock, the new column will show a
# negative cash flow of value of stock times 100. If the value of the strike
# price is less than or equal to the value of the stock, the new column will
# show a positive cash flow of premium.

# This will take the input, which expects option data and stock data (and
# therefore a Last column for the last price of the option and a Last.1 column
# for the last price of the stock), and outputs a Cash Flow column.
GetResults <- function(input, output = input)
{
    data <- read.csv(input, stringsAsFactors = FALSE)
    data['Cash Flow'] <- ifelse(data[['Strike']] > data[['Last.1']], -100 * data[['Strike']], data[['Premium']])

    write.csv(data, file = output, row.names = FALSE)
}
