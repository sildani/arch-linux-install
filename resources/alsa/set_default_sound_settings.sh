#!/bin/bash

# use "aplay -l" command to get a list of card IDs
# use "alsamixer" to verify settings / controls

amixer set Master 50%
sleep 1
amixer -c 1 set Headphone 100
sleep 1
amixer -c 1 set PCM 90%
sleep 1
amixer -c 1 set Front 80
sleep 1
amixer -c 1 set Master 63
sleep 1
amixer -c 2 set PCM 80%
