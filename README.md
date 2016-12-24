# ROptionsData

## Synopsis

ROptionsData uses R to aggregate helpful data about Options. Currently, the
Options module supports backing out strike prices for options closest to a
given delta. In general, you can use [get_Prices.R](get_Prices.R) at a later
date to backtest the results.

## Dependencies

All modules in this repository require the following R packages:
* quantmod
* RQuantLib
* jsonlite
* curl

Packages can be installed via `install.packages('<PACKAGE_NAME>')` and are case
sensitive. Alternatively, there is a wrapper shell script
[install.sh](install.sh) that, if run as root, will automatically download and
install the necessary packages from the repo you specify. You may omit the
repository to use a default.

## Example

Please refer to [input.csv](input.csv) for properly formatted input files or run
[this script](run.R).

Dates in the input file must be in the format MM/dd/yyyy.

```R
UpdateStocks('input.csv', 'stock_output.csv')
UpdateOptions('input.csv', 'options_output.csv')
```
