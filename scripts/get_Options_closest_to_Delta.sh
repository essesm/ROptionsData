#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "usage: $0 recipients"
    exit 1
fi

# Get the Friday after two weeks from today
DATE=$(echo `date -d '+2 weeks' '+%Y%m%d'`'\ +'{1..7}'\ days' | xargs -n1 date -d | grep Fri)

# Reformat the date to YYYYmmdd
DATE=`date -d"$DATE" '+%Y%m%d'`

OUTPUT="../output.$DATE.csv"
RECIPIENTS=$1

Rscript get_Options_closest_to_Delta.R $DATE -0.25 ../input.csv $OUTPUT |&  mail -s "Options for $DATE" $RECIPIENTS -A $OUTPUT
