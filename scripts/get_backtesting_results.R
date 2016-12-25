library(tools)
source('../modules/Stocks.R')

# Get args and filename and validate number of args
args <- commandArgs(trailingOnly = TRUE)
filename <- sub('.*=', '', commandArgs()[4])
if (length(args) != 1 && length(args) != 2)
{
    stop(paste('usage: ', filename, 'input [output]'))
}

# Parse args
input <- args[1]
output <- ifelse(length(args) == 2, args[2], paste(file_path_sans_ext(input), '.out.', file_ext(input), sep = ''))

# Get stock data and append cash flow based on Strike price and Last price
data <- read.csv(input, stringsAsFactors = FALSE)
results <- GetStock(data[['Symbol']])
results['Cash Flow'] <- ifelse(data[['Strike']] > results[['Last']], -100 * data[['Strike']], data[['Premium']])

write.csv(cbind(data, results), file = output, row.names = FALSE)
