#!/bin/bash
# James Willson 3/20/2025

# Set speaker and headphones
SPEAKER="alsa_output.pci-0000_12_00.0.analog-stereo"
HEADPHONES="alsa_output.pci-0000_17_00.6.analog-stereo"
MICROPHONE="alsa_input.pci-0000_17_00.6.analog-stereo"

volume() {
	pactl get-sink-volume $1 | head -1 | cut -d "/" -f 2 | tr -d '% '
}

### Prints current sink (good for i3blocks)
print_sink() {
	if (( $(pactl info | grep "Sink: $HEADPHONES" | wc -l) )); then 
		printf "%3.2d%% Headphones\n\n" "$(volume $HEADPHONES)"
	else
		printf "%3.2d%% Speakers  \n\n" "$(volume $SPEAKER)"
	fi
	[[ "$(pactl get-sink-mute @DEFAULT_SINK@)" = "Mute: yes" ]] && echo '#BF616A'
}

switch_to_sink() {
	pactl set-default-sink "$(pactl list sinks short | grep $1 | cut -d $'\t' -f 1)"
}

switch_to_source() {
	pactl set-default-source $(pactl list sources short | grep $1 | cut -d $'\t' -f 1)
}

### sets audio to how I want it when I start my computer
startup() {
	switch_to_source $MICROPHONE
	switch_to_sink $SPEAKER
}

### Switcher
toggle_sink() {
	if (( $(pactl info | grep "Sink: $HEADPHONES" | wc -l) )); then 
		switch_to_sink $SPEAKER
		echo "Switched to speakers"
	else
		switch_to_sink $HEADPHONES
		echo "Switched to headphones"
	fi
}

usage() {
	echo "Usage: $0 [-t|-s|-p|-h]"
	echo ""
	echo "Options:"
	echo "  -t, toggle output"
	echo "  -s, setup audio"
	echo "  -p, print current sink (i3blocks)"
	echo "  -h, show this message"
	exit 1
}

toggle_flag=0
setup_flag=0
print_flag=0

while getopts ":tsph" opt; do 
	case ${opt} in 
		t )
			toggle_flag=1
			;;
		s ) 
			setup_flag=1
			;;
		p ) 
			print_flag=1
			;;
		h )
			usage
			;;
		\? )
			echo "Invalid option: -$OPTARG" >&2
			usage
			;;
	esac
done

if (( toggle_flag + setup_flag + print_flag > 1 )); then
	echo "Error: must only choose one option" >&2
	usage
elif (( toggle_flag + setup_flag + print_flag == 0 )); then
	echo "Error: option required" >&2
	usage
fi

if (( toggle_flag )); then
	toggle_sink
elif (( setup_flag )); then 
	startup
elif (( print_flag )); then
	print_sink
fi
