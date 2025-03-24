#!/bin/bash
# James Willson 3/20/2025

# Set speaker and headphones
SPEAKER="alsa_output.pci-0000_12_00.0.analog-stereo"
HEADPHONES="alsa_output.pci-0000_17_00.6.analog-stereo"
MICROPHONE="alsa_input.pci-0000_17_00.6.analog-stereo"

volume() {
	[[ $muted = "Mute: yes" ]] || pactl get-sink-volume $1 | head -1 | cut -d "/" -f 2 | tr -d '% '
}

### Prints current sink (good for i3blocks)
print_sink() {
	muted="$(pactl get-sink-mute @DEFAULT_SINK@)"
	if (( $(pactl info | grep "Sink: $HEADPHONES" | wc -l) )); then 
		printf "Headphones%3.2d%%\n" "$(volume $HEADPHONES)"
	else
		printf "  Speakers%3.2d%%\n" "$(volume $SPEAKER)"
	fi

	# print red on mute
	if [ "$muted" = "Mute: yes" ]; then
		echo ""
		echo '#BF616A'
	fi
}

### sets audio to how I want it when I start my computer
startup() {
	pactl set-default-source $(pactl list sources short | grep $MICROPHONE | cut -d $'\t' -f 1)
	pactl set-default-sink $(pactl list sinks short | grep $SPEAKER | cut -d $'\t' -f 1)
}

### Switcher
toggle_sink() {
	if (( $(pactl info | grep "Sink: $HEADPHONES" | wc -l) )); then 
		pactl set-default-sink "$(pactl list sinks short | grep $SPEAKER | cut -d $'\t' -f 1)"
		echo "Switched to speakers"
	else
		pactl set-default-sink "$(pactl list sinks short | grep $HEADPHONES | cut -d $'\t' -f 1)"
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
