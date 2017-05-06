library(tools)
source('../modules/Options.R')

# Get args and filename and validate number of args
args <- commandArgs(trailingOnly = TRUE)
filename <- sub('.*=', '', commandArgs()[5])
if (length(args) != 4 && length(args) != 5)
{
    stop(paste('usage: ', filename, 'YYYYMMDD (put|call) delta input [output]'))
}

# Parse args
format <- '%Y%m%d'
date <- as.Date(args[1], format = format)
option <- args[2]
delta <- as.numeric(args[3])
input <- args[4]
output <- ifelse(length(args) == 5, args[5], paste(file_path_sans_ext(input), '.out.', file_ext(input), sep = ''))

# Error check args
if (is.na(date)) stop(paste('invalid date format', format))
if (is.na(delta) || delta < -1 || delta > 1) stop(paste('invalid delta: must be between -1 and 1'))

# Process each symbol, ignoring those that don't expire on the given date
data <- read.csv(input, stringsAsFactors = FALSE)
results <- NULL
for (symbol in data[['Symbol']])
{
    tryCatch(results <- rbind(results, GetOption(symbol, option, date, 'Delta', delta)),
             error = function(e) { print(paste(symbol, e)) }
             )
}

write.csv(merge(data, results), file = output, row.names = FALSE)
