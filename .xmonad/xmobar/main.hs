-- https://xmobar.org/

Config { 
    font            = "xft:Fira Sans:weight=bold:pixelsize=20:antialias=true:hinting=true,
                           Font Awesome 5 Brands:weight=regular:pixelsize=20:antialias=true:hinting=true,
                           FontAwesome:weight=regular:pixelsize=20:antialias=true:hinting=true",
    additionalFonts = [ "xft:MesloLGSDZ Nerd Font:weight=regular:pixelsize=20:antialias=true:hinting=true",
                        "xft:FontAwesome:pixelsize=13"],
    bgColor         = "#0d0d0d",
    position        = TopSize C 100 30,
    fgColor         = "#EBEBEB",
    lowerOnStart    = True,
    alpha           = 255,
    hideOnStart     = False,
    allDesktops     = True,
    persistent      = True,
    commands        = [ 
                        Run CoreTemp ["-t", "<fn=1>\xe20a </fn><core0>ºC"] 20,
                        Run Cpu ["-t", "<fn=0>\xf2db </fn><total>%","-H","50","--high","red"] 20,
                        Run Memory ["-t","Mem:<usedratio>%"] 20,
                        Run DiskU [("/", "<fn=0>\xf0c7 </fn>hdd:<used>/<size>")] [] 60,
                        Run Date " %d %b %-I:%M" "date" 600,
                        Run Com "/bin/sh" [ "-c", "~/.xmonad/xmobar/trayer-padding-icon.sh" ] "trayerpad" 20,
                        -- Run Com "bash" ["-c", "checkupdates | wc -l"] "updates" 3000,
                        -- Run Com "brightness" [] "brightness" 10,
                        -- Run Com "battery" [] "battery" 600,
                        -- Run Com "volume" [] "volume" 10,
                        Run UnsafeStdinReader
    ],
    alignSep        = "}{",
    template        = "<action=`~/.config/qtile/scripts/xmenu.sh`><fn=1>  </fn></action> \
                    \<fn=0>%UnsafeStdinReader%</fn> }{ \
                    \<fn=1><action=`alacritty -e bashtop`>\
                    \%coretemp% \
                    \%cpu% \
                    \%memory% \
                    \%disku% \
                    \</action>\
                    -- \ %updates% \
                    -- \ %brightness%\
                    -- \ %battery%\
                    -- \ %volume% \
                    \<action=`~/.config/qtile/scripts/calendar.sh`>%date%</action>\
                    \%trayerpad%</fn>"
}
