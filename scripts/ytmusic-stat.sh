#!/bin/bash
# James Willson 3/23/2025

PLAYER=$(playerctl -l | grep chromium\.instance)

parse_meta() {
	playerctl metadata -p "$PLAYER" | grep $1 | sed "s/.*$1[ \t]*//"
}

print_status() {
	status="$(playerctl status -p "$PLAYER")"
	[[ -z $status ]] && exit 1
	printf "%s - %s (%s)\n\n" "$(parse_meta "artist")" "$(parse_meta "title")" "$(parse_meta "album")"
	if [ $status = "Paused" ]; then
		echo '#BF616A'
	fi
}

print_status
