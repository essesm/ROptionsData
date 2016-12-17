library(tools)
source('Stocks.R')
source('Summary.R')

args = commandArgs(trailingOnly = TRUE)
if (length(args) == 0)
{
    stop("You must specify an input file\n", call. = FALSE)
}

input = args[1]
output = paste(file_path_sans_ext(input), ".out.", file_ext(input), sep = "")
UpdateStocks(input, output)
GetResults(output)
