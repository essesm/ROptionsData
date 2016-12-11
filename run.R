source('Options.R')

args <- commandArgs(trailingOnly = TRUE)
delta <- -0.25
input <- 'input.csv'
output <- 'output.csv'

if (length(args) == 1)
{
    delta <- args[1]
}

if (length(args) == 2)
{
    delta <- args[1]
    input <- args[2]
    output <- paste(file_path_sane_ext(input), ".out.", file_ext(input), sep <- "")
}

if (length(args) > 2)
{
    delta <- args[1]
    input <- args[2]
    output <- args[3]
}

UpdateOptions(as.numeric(delta), input, output)
