#!/bin/bash
# James Willson 3/23/2025

escape_markup() {
	sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

parse_meta() {
	playerctl metadata | grep $1 | sed "s/.*$1[ \t]*//"
}

print_status() {
	status="$(playerctl status)"
	[[ -z $status ]] && exit 1
	artist="$(parse_meta "artist" | escape_markup)"
	title="$(parse_meta "title" | escape_markup)"
	album="$(parse_meta "album" | escape_markup)"
	printf "%s - %s" "$artist" "$title"
	[[ -z "$album" ]] || printf " (%s)" "$album"
	printf "\n\n"
	[[ $status = "Paused" ]] && echo '#BF616A'
}

print_status
