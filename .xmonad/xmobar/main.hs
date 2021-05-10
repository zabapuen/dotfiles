-- http://projects.haskell.org/xmobar/

Config { 
    font    = "xft:Font Awesome 5 Brands:weight=regular:pixelsize=20:antialias=true:hinting=true, FontAwesome:weight=bold:pixelsize=20",
    additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=20:antialias=true:hinting=true",
                        "xft:FontAwesome:pixelsize=13"],
    bgColor = "#000000",
    position = TopSize C 100 30,
    fgColor = "#ffffff",
    lowerOnStart = True,
    alpha = 173,
    hideOnStart = False,
    allDesktops = True,
    persistent = True,
    commands = [ 
        Run Date " %d %b %-I:%M  " "date" 600,
        -- Run Com "volume" [] "volume" 10,
        -- Run Com "battery" [] "battery" 600,
        -- Run Com "brightness" [] "brightness" 10,
        Run Cpu ["-t", "<fn=0>\xf2db </fn>cpu:(<total>%)","-H","50","--high","red"] 20,
        -- Run Com "bash" ["-c", "checkupdates | wc -l"] "updates" 3000,
        Run Com "~/.xmonad/xmobar/trayer-padding-icon.sh" [] "trayerpad" 600,
        Run UnsafeStdinReader
    ],
    alignSep = "}{",
    template = "<action=`~/.config/qtile/scripts/xmenu.sh`>   </action> \
        \ <fn=0>%UnsafeStdinReader%</fn> }{ \
        \ %cpu%\
        -- \ %updates% \
        -- \ %brightness%\
        -- \ %battery%\
        -- \ %volume% \
        \ <action=`~/.config/qtile/scripts/calendar.sh`>%date%</action> \
        \%trayerpad%"
}
