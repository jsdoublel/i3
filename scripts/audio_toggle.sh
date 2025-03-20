#!/bin/bash
speaker_prefix="alsa_output.pci-0000_12_00"
headphones_prefix="alsa_output.pci-0000_17_00"
current="$(pactl info | grep Sink: | cut -d " " -f 3)"
if [ "1" = "$(pactl info | grep Sink: | grep $headphones_prefix | wc -l)" ]; then 
    echo "$(pactl list sinks short | grep $speaker_prefix | cut -d $'\t' -f 1)"
    pactl set-default-sink "$(pactl list sinks short | grep $speaker_prefix | cut -d $'\t' -f 1)"
    echo "Switched to speakers"
else
    echo "$(pactl list sinks short | grep $headphones_prefix | cut -d $'\t' -f 1)"
    pactl set-default-sink "$(pactl list sinks short | grep $headphones_prefix | cut -d $'\t' -f 1)"
    echo "Switched to headphones"
fi
# if [ "1" = "$(pactl info | grep Sink: | grep Logitech | wc -l)" ]; then 
#     echo "$(pactl list sinks short | grep $speaker_prefix | cut -d $'\t' -f 1)"
#     pactl set-default-sink "$(pactl list sinks short | grep $speaker_prefix | cut -d $'\t' -f 1)"
#     echo "Switched to speakers"
# else
#     echo "$(pactl list sinks short | grep "Logitech" | cut -d $'\t' -f 1)"
#     pactl set-default-sink "$(pactl list sinks short | grep "Logitech" | cut -d $'\t' -f 1)"
#     echo "Switched to headphones"
# fi

