args = commandArgs(trailingOnly = TRUE)
if (length(args) != 1)
{
    stop("You must specify repository\n", call. = FALSE)
}

repo <- args[1]
install.packages('quantmod', repo = repo)
install.packages('RQuantLib', repo = repo)
install.packages('jsonlite', repo = repo)
install.packages('curl', repo = repo)
