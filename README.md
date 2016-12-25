# ROptionsData

## Synopsis

ROptionsData uses R to aggregate helpful data about Options. Currently, you can
get an Option whose value for a specified key is closest to your input. For
example, you can retrieve the put that has a delta closest to -0.25.

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

A sample list of symbols can be found in [input.csv](input.csv).

```R
# Get the AAPL put with Delta closest to -0.25
option <- GetOption('AAPL', 'put', expiration.date, 'Delta', -0.25)
```
