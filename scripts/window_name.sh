#!/usr/bin/env bash
# James Willson
# 2025-10-03

MAX_LEN=40

trunc() { # use ... instead of elipse character you get from playerctl trunc
	(( ${#1} >= MAX_LEN )) && echo "$(echo "$1" | head -c $MAX_LEN)..." || echo "$1"
}

name=$(xdotool getwindowfocus getwindowname)
class=$(xdotool getwindowfocus getwindowclassname)
[[ -n $class && "${name^^}" == *"${class^^}" ]] && name=${name% -*}
if [[ ! -z $class ]]; then  
	printf '%s' "${class^^}" 
	[[ "${name^^}" != "${class^^}" ]] && printf ' [%s]' "$(trunc "$name")"
fi
printf '\n'

