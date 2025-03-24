#!/bin/bash
# James Willson 3/23/2025

PLAYER=$(playerctl -l | grep chromium\.instance)

escape_markup() {
    sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

parse_meta() {
	playerctl metadata -p "$PLAYER" | grep $1 | sed "s/.*$1[ \t]*//"
}

print_status() {
	status="$(playerctl status -p "$PLAYER")"
	[[ -z $status ]] && exit 1
	artist="$(parse_meta "artist" | escape_markup)"
    title="$(parse_meta "title" | escape_markup)"
    album="$(parse_meta "album" | escape_markup)"
	printf "%s - %s (%s)\n\n" "$artist" "$title" "$album"
	if [ $status = "Paused" ]; then
		echo '#BF616A'
	fi
}

print_status
