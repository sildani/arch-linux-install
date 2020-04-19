#!/bin/bash

# creates a script that can be invoked from i3 to set defaults for audio devices

ali_current_user=`whoami`
ali_set_audio_script="/home/$ali_current_user/bin/set_default_sound_settings.sh"

cat << 'EOF' > $ali_set_audio_script
#!/bin/bash

# use "aplay -l" command to get a list of card IDs
# use "alsamixer" to verify settings / controls

amixer set Master 50%
sleep 1
amixer -c `aplay -l | grep HD-Audio | head -1 | cut -b 5-6` set Headphone 100
sleep 1
amixer -c `aplay -l | grep HD-Audio | head -1 | cut -b 5-6` set PCM 90%
sleep 1
amixer -c `aplay -l | grep HD-Audio | head -1 | cut -b 5-6` set Front 80
sleep 1
amixer -c `aplay -l | grep HD-Audio | head -1 | cut -b 5-6` set Master 63
sleep 1
amixer -c `aplay -l | grep USB2.0 | head -1 | cut -b 5-6` set PCM 80%
sleep 1
amixer -c `aplay -l | grep "Plantronics .Audio 478 USB" | head -1 | cut -b 5-6` set Speaker 90%
sleep 1
amixer -c `aplay -l | grep "Plantronics .Audio 478 USB" | head -1 | cut -b 5-6` set Mic 87%
EOF

chmod +x $ali_set_audio_script

echo "
# audio setup
exec_always --no-startup-id $ali_set_audio_script" >> ~/.config/i3/config