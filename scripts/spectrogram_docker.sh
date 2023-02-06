#!/usr/bin/env bash
# Make sox spectrogram
source /home/birdie/BirdNET-Pi/config/birdnet.conf
analyzing_now="$(cat $HOME/BirdNET-Pi/config/analyzing_now.txt)"
spectrogram_png=${EXTRACTED}/spectrogram.png
sox -V1 "${analyzing_now}" -n remix 1 rate 24k spectrogram -c "${analyzing_now//$HOME\/}" -o "${spectrogram_png}"
