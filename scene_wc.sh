#!/bin/sh

raw_wc=`wc $1 | awk '{ print $2 }'`
filtered_wc=`grep -v ^% $1 | wc | awk '{ print $2 }'`

echo "$raw_wc,$filtered_wc"
