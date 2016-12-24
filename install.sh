#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)
repo <- ifelse(length(args), args[1], 'http://cran.us.r-project.org')

install.packages('quantmod', repo = repo)
install.packages('RQuantLib', repo = repo)
install.packages('jsonlite', repo = repo)
install.packages('curl', repo = repo)
