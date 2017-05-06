library(tools)
source('../modules/Stocks.R')

# Get args and filename and validate number of args
args <- commandArgs(trailingOnly = TRUE)
filename <- sub('.*=', '', commandArgs()[4])
if (length(args) != 2 && length(args) != 3)
{
    stop(paste('usage: ', filename, '(call|put) input [output]'))
}

# Parse args
option <- args[1]
input <- args[2]
output <- ifelse(length(args) == 3, args[3], paste(file_path_sans_ext(input), '.out.', file_ext(input), sep = ''))

# Get stock data and append cash flow based on Strike price and Last price
data <- read.csv(input, stringsAsFactors = FALSE)
results <- GetStock(data[['Symbol']])
if (option == 'call')
{
    results['Cash Flow'] <- ifelse(data[['Strike']] < results[['Last']], -100 * data[['Strike']], data[['Premium']])
} else if (option == 'put') {
    results['Cash Flow'] <- ifelse(data[['Strike']] > results[['Last']], -100 * data[['Strike']], data[['Premium']])
} else {
    stop(paste('invalid option type: ', type, ', use \'put\' or \'call\''))
}

write.csv(cbind(data, results), file = output, row.names = FALSE)
