#!/usr/bin/env sh

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#Special python script for auto wallpaper and colorscheme change
~/.config/qtile/scripts/pywal-colors-fav.py &

# conky -c ~/.config/conky/conky.conf &

#starting utility applications at boot time
run lxsession &
/usr/lib/polkit-kde-authentication-agent-1 &
numlockx on &
# run dex -ae qtile
# run xscreensaver -no-splash &
run volumeicon &
# run nm-applet &
run pamac-tray &
run copyq &
run polychromatic-tray-applet &
run blueman-applet &
run flameshot &
run thunar --daemon &
/var/lib/snapd/snap/bin/mailspring --background %U &
run dunst &
run picom &
run cbatticon &
paleofetch --recache &
xset s off -dpms &
udisksctl mount -b /dev/sdb1 &
#udisksctl mount -b /dev/sda2 &
# picom -b --config ~/.config/picom/picom.conf &
# ~/.conky/conky-startup.sh &
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
