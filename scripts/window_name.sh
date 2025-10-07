#!/usr/bin/env bash
# James Willson
# 2025-10-03

MAX_LEN=40

trunc() { 
	(( ${#1} >= MAX_LEN )) && echo "$(echo "$1" | head -c $MAX_LEN)..." || echo "$1"
}

name=$(xdotool getwindowfocus getwindowname | iconv -f UTF-8 -t ASCII -c)
class=$(xdotool getwindowfocus getwindowclassname | iconv -f UTF-8 -t ASCII -c)
[[ -n $class && "${name^^}" == *"${class^^}" ]] && name=${name% -*}
if [[ ! -z $class ]]; then  
	printf '%s' "${class^^}" 
	[[ "${name^^}" != "${class^^}" ]] && printf ' [%s]' "$(trunc "$name")"
fi
printf '\n'

