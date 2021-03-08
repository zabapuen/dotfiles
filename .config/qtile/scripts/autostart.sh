#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}


#Special python script for auto wallpaper and colorscheme change
~/.config/qtile/scripts/pywal-colors.py


#feh --bg-fill ~/.config/qtile/flower.jpg &
# conky -c ~/.config/conky/conky.conf &


#starting utility applications at boot time
run lxsession &
run xscreensaver -no-splash &
run nm-applet &
run pamac-tray &
numlockx on &
run polychromatic-tray-applet &
# blueman-applet &
run flameshot &
run volumeicon &
run dunst &
picom --config $HOME/.config/picom/picom.conf &
# /usr/lib/polkit-kde-authentication-agent-1 &


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

