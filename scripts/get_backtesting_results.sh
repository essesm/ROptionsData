#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "usage: $0 recipients [input] [output]"
    exit 1
fi

DATE=`date -d 'last Friday' '+%Y%m%d'`
RECIPIENTS=$1
INPUT=${2:-"../input.$DATE.csv"}
OUTPUT=${3:-"${INPUT%.*}.out.csv"}
touch $OUTPUT

Rscript get_backtesting_results.R $INPUT $OUTPUT |& mail -s "Backtesting results for $DATE" $RECIPIENTS -A $OUTPUT
