#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "usage: $0 (put|call) recipients [input] [output]"
    exit 1
fi

DATE=`date -d 'last Friday' '+%Y%m%d'`
OPTIONS=$1
RECIPIENTS=$2
INPUT=${3:-"../input.$DATE.$OPTIONS.csv"}
OUTPUT=${4:-"${INPUT%.*}.out.csv"}
touch $OUTPUT

Rscript get_backtesting_results.R $OPTIONS $INPUT $OUTPUT |& mail -s "Backtesting results for $OPTIONS options on $DATE" $RECIPIENTS -A $OUTPUT
