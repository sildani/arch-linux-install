#!/bin/bash

# sets resolution, and refresh rate of specific display
xrandr
echo -n "
Set xrandr in i3 config?

Example: --output DisplayPort-1 --mode 2560x1440 --rate 120.00

Leave blank to accept default example above, or type in another xrandr setting, or type N to exit without changes
> "
read ali_xrandr_command
case "$ali_xrandr_command" in
"N")
  echo "Doing nothing"
  ;;
"")
  read -p "Adding \`xrandr --output DisplayPort-1 --mode 2560x1440 --rate 120.00\` to i3 config... press enter to continue"
  echo "
# video setup
exec_always --no-startup-id xrandr --output DisplayPort-1 --mode 2560x1440 --rate 120.00" >> ~/.config/i3/config
  ;;
*)
  read -p "Adding \`xrandr $ali_xrandr_command\` to i3 config... press enter to continue"
  echo "
# video setup
exec_always --no-startup-id xrandr $ali_xrandr_command" >> ~/.config/i3/config
  ;;
esac