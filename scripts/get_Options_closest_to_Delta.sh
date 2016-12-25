#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "usage: $0 recipients input [output]"
    exit 1
fi

# Get the Friday after two weeks from today
DATE=$(echo `date -d '+2 weeks' '+%Y%m%d'`'\ +'{1..7}'\ days' | xargs -n1 date -d | grep Fri)

# Reformat the date to YYYYmmdd
DATE=`date -d"$DATE" '+%Y%m%d'`

RECIPIENTS=$1
INPUT=$2
OUTPUT=${3:-"${INPUT%.*}.$DATE.csv"}
touch $OUTPUT

Rscript get_Options_closest_to_Delta.R $DATE -0.25 $INPUT $OUTPUT |&  mail -s "Options for $DATE" $RECIPIENTS -A $OUTPUT
