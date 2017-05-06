#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "usage: $0 recipients (put|call) delta input [output]"
    exit 1
fi

# Get the Friday after two weeks from today
DATE=$(echo `date -d '+2 weeks' '+%Y%m%d'`'\ +'{1..7}'\ days' | xargs -n1 date -d | grep Fri)

# Reformat the date to YYYYmmdd
DATE=`date -d"$DATE" '+%Y%m%d'`

RECIPIENTS=$1
OPTION=$2
DELTA=$3
INPUT=$4
OUTPUT=${5:-"${INPUT%.*}.$DATE.$OPTION.csv"}
touch $OUTPUT

Rscript get_Options_closest_to_Delta.R $DATE $OPTION $DELTA $INPUT $OUTPUT |&  mail -s "$OPTION options for $DATE" $RECIPIENTS -A $OUTPUT
