#!/bin/bash
while sleep 5; do
	vpn=$(pgrep -lf openvpn | awk '{print $NF}' | sort -u | xargs)
	tosleep=$((180 - $(xssstate -i) / 1000))
	if [ $tosleep -le 30 ]; then
		sleepwarning="Sleeping Soon! "
	else
		sleepwarning=""
	fi
	now=$(date '+%b %-d %-H:%M')
	project=$(timecard --current)
	xsetroot -name "$sleepwarning{$project} [$vpn] $now"
done
