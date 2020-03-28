#!/usr/bin/env sh
#
# Terminate already running bar instances
# killall -q polybar
# Wait until the processes have been shut down
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
# Launch bar1 and bar2
# polybar example &

killall -q polybar &

listpid=$(getpid "i3listen.py")
[[ -n $listpid ]] && kill "$listpid"

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done &

i3fehrb > /dev/null 2>&1 &

#. $HOME/.fehbg

MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')

if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | cut -d ":" -f1); do
    	MONITOR=$m polybar -c ~/.config/polybar/config --reload example &
	done
else
	polybar -c ~/.config/polybar/config example --reload &
fi

# start listener
i3listen.py > /dev/null 2>&1 &
