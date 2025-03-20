#!/bin/bash
# James Willson 3/20/2025

# Set speaker and headphones (can be substring, just needs to be grep-able)
SPEAKER="alsa_output.pci-0000_12_00"
HEADPHONES="alsa_output.pci-0000_17_00"
MICROPHONE="alsa_input.pci-0000_17_00"

### Prints current sink (good for i3blocks)
print_sink() {
	if [ "1" = "$(pactl info | grep Sink | grep "alsa_output.pci-0000_17_00" | wc -l)" ]; then 
		echo "Headphones"
	else
		echo " Speakers "
	fi

	# print red on mute
	if [ "$(pactl get-sink-mute @DEFAULT_SINK@)" = "Mute: yes" ]; then
		echo ""
		# echo '#FF0000'
		echo '#BF616A'
	else
		# echo ""
		echo '#00FF00'
	fi
}

### sets audio to how I want it when I start my computer
startup() {
	pactl set-default-source $(pactl list sources short | grep "input" | grep $MICROPHONE | cut -d $'\t' -f 1)
	pactl set-default-sink $(pactl list sinks short | grep "output" | grep $SPEAKER | cut -d $'\t' -f 1)
}

### Switcher
toggle_sink() {
	current="$(pactl info | grep Sink: | cut -d " " -f 3)"
	if [ "1" = "$(pactl info | grep Sink: | grep $HEADPHONES | wc -l)" ]; then 
		echo "$(pactl list sinks short | grep $SPEAKER | cut -d $'\t' -f 1)"
		pactl set-default-sink "$(pactl list sinks short | grep $SPEAKER | cut -d $'\t' -f 1)"
		echo "Switched to speakers"
	else
		echo "$(pactl list sinks short | grep $HEADPHONES | cut -d $'\t' -f 1)"
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
