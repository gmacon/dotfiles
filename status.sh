#!/bin/bash
sleepperiod=5
while sleep $sleepperiod; do
	sleepwarning=""
	sleepperiod=5
	case $(xssstate -s) in
		on)
			sxlock -f "-*-terminus-medium-*-normal--32-*-*-*-*-*-*-u";;
		off)
			tosleep=$(($(xssstate -t) / 1000))
			if [ $tosleep -le 30 ]; then
				sleepwarning="Sleeping in $tosleep! "
				sleepperiod=1
			fi;;
	esac
	now=$(date '+%a %b %-d %-H:%M')
	utcnow=$(date -u '+%-H:%MZ')
	project=$(timecard --current)
	xsetroot -name "$sleepwarning{$project} $now $utcnow"
done
