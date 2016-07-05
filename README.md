# OptionsStrategies

## Synopsis

OptionsStrategies uses R to impliment options trading strategies.

## Dependencies

All modules in this repository require the following R packages:
* XML
* RQuantLib
* quantmod

Packages can be installed via `install.packages('<PACKAGE_NAME>')` and are case
sensitive.

## Example

Please refer to [input.csv](input.csv) for properly formatted input files or run
[this script](run.R).

Dates in the input file must be in the format yyyy-mm-dd.

```R
UpdateStocks('input.csv', 'stock_output.csv')
UpdateOptions('input.csv', 'options_output.csv')
```
