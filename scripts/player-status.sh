#!/usr/bin/env bash
# James Willson 3/23/2025

MAX_LEN=35

trunc() { # use ... instead of elipse character you get from playerctl trunc
	data=$(playerctl metadata --format "{{markup_escape($1)}}")
	(( ${#data} >= MAX_LEN )) && echo "$(echo "$data" | head -c $MAX_LEN)..." || echo "$data"
}

progress() {
	playerctl metadata --format '{{duration(position)}}/{{duration(mpris:length)}}'
}

print_status() {
	status="$(playerctl status)"
    [[ -z $status || "$status" == "Stopped" ]] && (printf ' \n'; exit 0) # \n makes player spacing persistant
	printf "%s {%s} " "${status^^}" "$(progress)"
	artist="$(trunc "artist")"
	title="$(trunc "title")"
	album="$(trunc "album")"
	printf "%s - %s" "$artist" "$title"
	[[ -z "$album" ]] || printf " [%s]" "$album"
	printf '<span foreground="#FFFFFF"> ||</span>'
	printf "\n\n"
	[[ $status = "Paused" ]] && echo '#BF616A'
}

print_status
