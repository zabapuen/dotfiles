  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen, nextWS, prevWS)
import XMonad.Actions.GridSelect
-- import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe ( fromJust, isJust )
import Data.Monoid
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat, isDialog)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.PerWorkspace
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

import XMonad.Operations
import qualified XMonad.StackSet as W

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:MesloLGSDZ Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty "    -- Sets default terminal

myBrowser :: String
myBrowser = "google-chrome-stable "  -- Sets qutebrowser as browser

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

myEditor :: String
myEditor = "vim"  -- Sets vim as editor
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 0           -- Sets border width for windows

myNormColor :: String
myNormColor   = "#282c34"   -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#46d9ff"   -- Border color of focused windows

altMask :: KeyMask
altMask = mod1Mask          -- Setting this for use in xprompts

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    -- spawnOnce "lxsession &"
    -- spawnOnce "picom &"
    -- spawnOnce "nm-applet &"
    -- spawnOnce "volumeicon &"
    -- spawnOnce "conky -c $HOME/.config/conky/xmonad.conkyrc"
    -- spawnOnce "/usr/bin/emacs --daemon &" -- emacs daemon for the emacsclient
    -- spawnOnce "kak -d -s mysession &"  -- kakoune daemon for better performance
    -- spawnOnce "urxvtd -q -o -f &"      -- urxvt daemon for better performance
    -- spawnOnce "xargs xwallpaper --stretch < ~/.xwallpaper"  -- set last saved with xwallpaper
    -- spawnOnce "/bin/ls ~/.local/share/wallpapers | shuf -n 1 | xargs xwallpaper --stretch"  -- set random xwallpaper
    -- spawnOnce "~/.fehbg &"  -- set last saved feh wallpaper
    -- spawnOnce "feh --randomize --bg-fill ~/.local/share/wallpapers/*"  -- feh set random wallpaper
    -- spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
    spawnOnce "~/.config/qtile/scripts/autostart.sh &"  -- autostart programs
    spawnOnce "xsetroot -cursor_name left_ptr &"  -- X mouse
    spawnOnce "trayer --edge top --align right --distancefrom right --distance 180 --widthtype request --padding 3 --iconspacing 3 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 82 --tint 0x0D0D0D --height 30 &"
    setWMName "LG3D"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Audacity", "audacity")
                 , ("Deadbeef", "deadbeef")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("google-chrome-stable", "google-chrome-stable")
                 , ("Geany", "geany")
                 , ("Geary", "geary")
                 , ("Gimp", "gimp")
                 , ("Kdenlive", "kdenlive")
                 , ("LibreOffice Impress", "loimpress")
                 , ("LibreOffice Writer", "lowriter")
                 , ("OBS", "obs")
                 , ("PCManFM", "pcmanfm")
                 ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "spoty" spawnSpoty findSpoty manageSpoty
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnSpoty  = myTerminal ++ "-t spoty -e ~/.local/bin/spoty"
    findSpoty   = title =? "spoty"
    manageSpoty = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
-- monadtall = ResizableTall 1 (3/100) (17/25) [] 
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (17/25) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
-- magnify  = renamed [Replace "magnify"]
--            $ smartBorders
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ magnifier
--            $ limitWindows 12
--            $ mySpacing 8
--            $ ResizableTall 1 (3/100) (1/2) []
-- threeCol = renamed [Replace "threeCol"]
--            $ smartBorders
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 7
--            $ ThreeCol 1 (3/100) (1/2)
-- threeRow = renamed [Replace "threeRow"]
--            $ smartBorders
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 7
--            -- Mirror takes a layout and rotates it by 90 degrees.
--            -- So we are applying Mirror to the ThreeCol layout.
--            $ Mirror
--            $ ThreeCol 1 (3/100) (1/2)
-- tabs     = renamed [Replace "tabs"]
--            -- I cannot add spacing to this layout because it will
--            -- add spacing between window and tabs which looks bad.
--            $ tabbed shrinkText myTabTheme
-- tallAccordion  = renamed [Replace "tallAccordion"] Accordion
-- wideAccordion  = renamed [Replace "wideAccordion"]
        --    $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
-- myShowWNameTheme :: SWNConfig
-- myShowWNameTheme = def
--     { swn_font              = "xft:Font Awesome 5 Brands:weight=regular:pixelsize=60, FontAwesome:weight=regular:pixelsize=60"
--     , swn_fade              = 1.0
--     , swn_bgcolor           = "#1c1f24"
--     , swn_color             = "#ffffff"
--     }

-- The layout hook  -- $ modWorkspaceSource "  \xf268  " ResizableTall 1 (3/100) (17/25) [] tall
myLayoutHook = avoidStruts $ windowArrange $ T.toggleLayouts floats $ onWorkspace "  \xf3ca  " floats 
               $ onWorkspace "  \xf395  " grid $ onWorkspace "  \xf26c  " monocle
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     noBorders tall
                                 ||| noBorders monocle
                                 ||| noBorders floats
                                 ||| noBorders grid
                                 ||| noBorders spirals
                                --  ||| noBorders tabs
                                --  ||| noBorders magnify
                                --  ||| noBorders threeCol
                                --  ||| noBorders threeRow
                                --  ||| noBorders tallAccordion
                                --  ||| noBorders wideAccordion

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
-- myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
--                                                                                         -- sarosi
--    $ ["\xf269 ", "\xe235 ", "\xe795 ", "\xf121 ", "\xe615 ", "\xf74a ", "\xf7e8 ", "\xf03d ", "\xf827 "] -- sarosi
-- myWorkspaces = ["\xf269 ", "\xe235 ", "\xe795 ", "\xf121 ", "\xe615 ", "\xf74a ", "\xf7e8 ", "\xf03d ", "\xf827 "] -- Nerd Font

myWorkspaces = ["  \xf268  ", "  \xf120  ", "  \xf395  ", "  \xf3ca  ", "  \xf1bc  ", "  \xf4f9  ", "  \xf26c  "] -- NF & FA
-- myWorkspaces = ["\xf268 ", "\xf120 ", "\xf308 ", "\xf871 ", "\xf1bc ", "\xf11b ", "\xfc44 ", "\xf232 ", "\xf26c "] -- Nerd Font
-- myWorkspaces = ["\xf268 ", "\xf120 ", "\xf395", "\xf3ca", "\xf1bc", "\xf412 ", "\xf838", "\xf4f9", "\xf26c "] -- Font Awesome
-- myWorkspaces = [" \xf268 ", " \xf120 ", " \xf395 ", " \xf3ca ", " \xf1bc ", " \xf4f9 ", " \xf26c ", " \xf26c ", " \xf26c "]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..7] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [ isDialog                       --> doCenterFloat
     , className =? "confirm"         --> doCenterFloat
     , className =? "file_progress"   --> doCenterFloat
     , className =? "dialog"          --> doCenterFloat
     , className =? "download"        --> doCenterFloat
     , className =? "error"           --> doCenterFloat
     , className =? "Gimp"            --> doCenterFloat
     , className =? "notification"    --> doCenterFloat
     , className =? "CopyQ"           --> doCenterFloat
     , className =? "copyq"           --> doCenterFloat
     , className =? "pinentry-gtk-2"  --> doCenterFloat
     , className =? "splash"          --> doCenterFloat
     , className =? "Pamac-manager"   --> doCenterFloat
     , className =? "feh"             --> doCenterFloat
     , className =? "Mailspring"      --> doCenterFloat
     , className =? "Sysmontask"      --> doCenterFloat
     , className =? "toolbar"         --> doCenterFloat
     , className =? "Wine"            --> doCenterFloat
     , title =? "Oracle VM VirtualBox Manager"  --> doCenterFloat
     , className =? "UXXI"            --> doShift ( myWorkspaces !! 5 )
     , className =? "DEV"             --> doShift ( myWorkspaces !! 1 )
     , className =? "rdesktop"        --> doShift ( myWorkspaces !! 6 )
     , className =? "Microsoft Teams - Preview" --> doShift  ( myWorkspaces !! 5 )
     , (className =? "google-chrome-stable" <&&> resource =? "Dialog") --> doCenterFloat  -- Float Firefox Dialog
     ] <+> namedScratchpadManageHook myScratchPads

centerWindow :: Window -> X ()
centerWindow win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile && xmonad --restart")  -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")    -- Restarts xmonad
        , ("M-S-q", io exitSuccess)              -- Quits xmonad
        , ("M-q", kill1)                         -- Kill the currently focused client
        -- , ("M-S-q", killAll)                     -- Kill all windows on current workspace
        , ("M-S-l", spawn "dm-tool lock")                     -- Lock Session


    -- Run Prompt
    -- M-p was the default keybinding.  I've changed it to M-S-RET because I will use
    -- M-p as part of the keychord for the other dmenu script bindings.
        , ("M-d", spawn "~/.config/qtile/scripts/dmenu.sh") -- Dmenu ~/.config/qtile/scripts/xmenu.sh rofi -show run
        , ("M-S-d", spawn "~/.config/qtile/scripts/xmenu.sh") -- Dmenu ~/.config/qtile/scripts/xmenu.sh
        , ("M-<Space>", spawn "~/.config/eww/launch_eww")          -- eww
        , ("M-<Esc>", spawn "xkill")                        -- Xkill
        , ("M", spawn "~/.config/qtile/scripts/dmenu.sh") -- Dmenu ~/.config/qtile/scripts/xmenu.sh
        , ("M1-M", spawn "~/.config/qtile/scripts/dmenu.sh")
        , ("M-c", withFocused centerWindow)
        

    -- Useful programs to have a keybinding for launch
        , ("M-<Return>", spawn myTerminal)
        , ("M1-f", spawn myBrowser)
        , ("M1-m", spawn "thunar")
        , ("M-M1-h", spawn (myTerminal ++ " -e htop"))
        , ("M-w", spawn "~/.config/qtile/scripts/pywal-colors.py")
        , ("M-S-w", spawn "~/.config/qtile/scripts/pywal-colors-fav.py")
        , ("M-s", spawn (myTerminal ++ " -e ~/.local/bin/spoty"))
        , ("M-S-s", spawn "spotify")
        , ("M-u", spawn "~/.config/qtile/scripts/rdesktop.sh")
        , ("C-M1-o", spawn "~/.config/qtile/scripts/picom-toggle.sh")

    -- Workspaces
        , ("M1-<Left>", prevWS)  -- Switch focus to prev monitor
        , ("M1-<Right>", nextWS)  -- Switch focus to prev monitor
        , ("M-S-<Right>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<Left>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Floating windows
        , ("M-S-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("M--", decWindowSpacing 4)           -- Decrease window spacing
        , ("M-+", incWindowSpacing 4)           -- Increase window spacing
        -- , ("M-S-d", decScreenSpacing 4)         -- Decrease screen spacing
        -- , ("M-S-i", incScreenSpacing 4)         -- Increase screen spacing

    -- Windows navigation
        , ("M-S-<Down>", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-<Up>", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-<Down>", windows W.focusDown)    -- Move focus to the next window
        , ("M-<Up>", windows W.focusUp)      -- Move focus to the prev window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-S-<Space>", sinkAll)                       -- Push ALL floating windows to tile
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)  -- Toggles noborder
        , ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-+", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S--", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-+", increaseLimit)                   -- Increase # of windows
        , ("M-C--", decreaseLimit)                 -- Decrease # of windows

    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-C-<Left>", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-C-<Right>", sendMessage Expand)                   -- Expand horiz window width
        , ("M-C-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-C-k", sendMessage MirrorExpand)          -- Expand vert window width
        , ("M-C-<Up>", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-C-<Down>", sendMessage MirrorExpand)          -- Expand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        -- , ("M-C-h", sendMessage $ pullGroup L)
        -- , ("M-C-l", sendMessage $ pullGroup R)
        -- , ("M-C-k", sendMessage $ pullGroup U)
        -- , ("M-C-j", sendMessage $ pullGroup D)
        -- , ("M-C-m", withFocused (sendMessage . MergeAll))
        -- , ("M-C-u", withFocused (sendMessage . UnMerge))
        -- , ("M-C-/", withFocused (sendMessage . UnMergeAll))
        -- , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        -- , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

    -- Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("C-m t", namedScratchpadAction myScratchPads "terminal")
        , ("C-m s", namedScratchpadAction myScratchPads "spoty")
        , ("C-m c", namedScratchpadAction myScratchPads "calculator")
        , ("C-m a", namedScratchpadAction myScratchPads "copyq")

    -- Set wallpaper with 'feh'. Type 'SUPER+F1' to launch sxiv in the wallpapers directory.
    -- Then in sxiv, type 'C-x w' to set the wallpaper that you choose.
        , ("M-<F1>", spawn "sxiv -r -q -t -o ~/.local/share/wallpapers/*")
        , ("M-<F2>", spawn "/bin/ls -d ~/.local/share/wallpapers/* | shuf -n 1 | xargs xwallpaper --zoom")
        --, ("M-<F2>", spawn "feh --randomize --bg-fill ~/.local/share/wallpapers/*")

    -- Controls for mocp music player (SUPER-u followed by a key)
        -- , ("M-u p", spawn "playerctl play")
        -- , ("M-u l", spawn "playerctl next")
        -- , ("M-u h", spawn "playerctl previous")
        -- , ("M-u <Space>", spawn "playerctl toggle-pause")

    -- Emacs (CTRL-e followed by a key)
        -- , ("C-e e", spawn myEmacs)                 -- start emacs
        , ("C-e e", spawn (myEmacs ++ "--eval '(dashboard-refresh-buffer)'"))   -- emacs dashboard
        , ("C-e b", spawn (myEmacs ++ "--eval '(ibuffer)'"))   -- list buffers
        , ("C-e d", spawn (myEmacs ++ "--eval '(dired nil)'")) -- dired
        , ("C-e i", spawn (myEmacs ++ "--eval '(erc)'"))       -- erc irc client
        , ("C-e m", spawn (myEmacs ++ "--eval '(mu4e)'"))      -- mu4e email
        , ("C-e n", spawn (myEmacs ++ "--eval '(elfeed)'"))    -- elfeed rss
        , ("C-e s", spawn (myEmacs ++ "--eval '(eshell)'"))    -- eshell
        , ("C-e t", spawn (myEmacs ++ "--eval '(mastodon)'"))  -- mastodon.el
        -- , ("C-e v", spawn (myEmacs ++ ("--eval '(vterm nil)'"))) -- vterm if on GNU Emacs
        , ("C-e v", spawn (myEmacs ++ "--eval '(+vterm/here nil)'")) -- vterm if on Doom Emacs
        -- , ("C-e w", spawn (myEmacs ++ ("--eval '(eww \"distrotube.com\")'"))) -- eww browser if on GNU Emacs
        , ("C-e w", spawn (myEmacs ++ "--eval '(doom/window-maximize-buffer(eww \"distrotube.com\"))'")) -- eww browser if on Doom Emacs
        -- emms is an emacs audio player. I set it to auto start playing in a specific directory.
        , ("C-e a", spawn (myEmacs ++ "--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'"))

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("<XF86AudioMute>",   spawn "amixer set Master toggle")
        -- , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        -- , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>", spawn "google-chrome-stable")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
        , ("<XF86Search>", safeSpawn "google-chrome-stable" ["https://www.google.com/"])
        , ("<XF86Mail>", runOrRaise "thunderbird" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
        , ("<XF86Eject>", spawn "toggleeject")
        -- , ("<Print>", spawn "spectacle -c")
        -- , ("M-C-<Print>", spawn "spectacle -c -r")
        , ("<Print>", spawn "flameshot screen -c -p ~/Imágenes/Screenshots/")
        , ("M-S-<Print>", spawn "flameshot gui")
        ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.xmonad/xmobar/main.hs"
    -- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.xmonad/xmobar/xmobarrc2"
    -- xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.xmonad/xmobar/xmobarrc1"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        -- To compile xmonadctl: ghc -dynamic xmonadctl.hs
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
                               <+> fullscreenEventHook  -- this does NOT work right if using multi-monitors!
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , focusFollowsMouse  = False
        , clickJustFocuses   = False                    -- Previene el doble clic cuando usamos focusFollowsMouse  = False
        , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = hPutStrLn xmproc0                                        -- xmobar on monitor 1
                            --   >> hPutStrLn xmproc1 x                             -- xmobar on monitor 2
                            --   >> hPutStrLn xmproc2 x                             -- xmobar on monitor 3
              , ppCurrent = xmobarColor "#A0E521" "#2F343F" . wrap "" ""            -- Current workspace (Purple #C50ED2)
              , ppVisible = xmobarColor "#A0E521" "" . clickable                    -- Visible but not current workspace (Purple #C50ED2)
              , ppHidden = xmobarColor "#A0E521" "" . wrap "" "" . clickable        -- Hidden workspaces (Purple #C50ED2)
              , ppHiddenNoWindows = xmobarColor "#EBEBEB" ""  . wrap "" "" . clickable     -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#EBEBEB" "" . shorten 60                     -- Title of active window
              , ppSep =  "<fc=#c0c5ce> <fn=1>|</fn> </fc>"                          -- Separator character
              , ppUrgent = xmobarColor "#FF301B" "" . wrap "" " "                   -- Urgent workspace
              , ppExtras  = [windowCount]                                           -- # of windows current workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                          -- order of things in xmobar
              }
        } `additionalKeysP` myKeys
