#!/usr/bin/env sh
jgmenu_run
# if pgrep -x "jgmenu_run" > /dev/null
# then
# 	killall jgmenu_run
# else
# 	jgmenu_run
# fi




# cat <<EOF | xmenu -p 2x30 | sh &
# $(cat $HOME/.config/qtile/scripts/menu.txt)
# IMG:/home/alejandro.garuda/.cache/xdg-xmenu/icons/system-reboot.png		Reboot		reboot
# IMG:/home/alejandro.garuda/.cache/xdg-xmenu/icons/system-suspend.png		Shutdown		poweroff
# EOF


# xdg-xmenu > $HOME/.config/qtile/scripts/menu.txt
# xdg-xmenu > menu; xmenu -p 0x25 < menu | sh
# Applications
# 	IMG:./icons/web.png	Web Browser	firefox
# 	IMG:./icons/gimp.png	Image editor	gimp
# Terminal (xterm)	xterm
# Terminal (urxvt)	urxvt
# Terminal (st)		st