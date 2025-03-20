#!/bin/bash

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
