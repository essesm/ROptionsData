# OptionsStrategies

## Synopsis

OptionsStrategies uses R to implement options trading strategies. Currently,
the Options module supports backing out strike prices for options given a
delta closest to a given delta. In general, you can use [get_Prices.R](get_Prices.R)
at a later date to backtest the results.

## Dependencies

All modules in this repository explicitly require the following R packages:
* RQuantLib
* quantmod

Packages can be installed via `install.packages('<PACKAGE_NAME>')` and are case
sensitive.

## Example

Please refer to [input.csv](input.csv) for properly formatted input files or run
[this script](run.R).

Dates in the input file must be in the format MM/dd/yyyy.

```R
UpdateStocks('input.csv', 'stock_output.csv')
UpdateOptions('input.csv', 'options_output.csv')
```
