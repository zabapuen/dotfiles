#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}


#Special python script for auto wallpaper and colorscheme change
~/.config/qtile/scripts/pywal-colors-fav.py


#feh --bg-fill ~/.config/qtile/flower.jpg &
# conky -c ~/.config/conky/conky.conf &


#starting utility applications at boot time
run lxsession &
numlockx on &
# run dex -ae qtile
run xscreensaver -no-splash &
run volumeicon &
run nm-applet &
run pamac-tray &
run polychromatic-tray-applet &
run blueman-applet &
run flameshot &
run thunar --daemon &
/var/lib/snapd/snap/bin/mailspring --background %U &
run dunst &
# run picom &
picom -b --config ~/.config/picom/picom.conf &
/usr/lib/polkit-kde-authentication-agent-1 &
~/.conky/conky-startup.sh &
#starting user applications at boot time
#run discord &
#nitrogen --random --set-zoom-fill &
#run caffeine -a &
#run vivaldi-stable &
#run firefox &
#run thunar &
#run dropbox &
#run insync start &
#run spotify &
#run atom &
#run telegram-desktop &
#run mailspring &
#run teams &
