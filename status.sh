#!/bin/sh
sleepperiod=5
while sleep $sleepperiod; do
	now=$(date '+%a %b %-d %-H:%M')
	xsetroot -name "$now"
done
