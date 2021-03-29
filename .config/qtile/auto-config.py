
import os
import re
import socket
import subprocess
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook, qtile
from libqtile.widget import Spacer
import albattery
import psutil
import json

# mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


myTerm = "alacritty"  # My terminal of choice

keys = [



    # SUPER + FUNCTION KEYS

    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "m", lazy.spawn('pragha')),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "t", lazy.spawn('teamspeak3')),
    Key([mod], "v", lazy.spawn('pavucontrol')),
    # Key([mod], "d", lazy.spawn('nwggrid -p -o 0.4')),
    Key([mod], "d", lazy.spawn(
        home + '/.config/qtile/scripts/dmenu.sh')),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "Return", lazy.spawn('alacritty')),
    Key([mod], "KP_Enter", lazy.spawn('alacritty')),
    Key([mod], "w", lazy.spawn(home + '/.config/qtile/scripts/pywal-colors.py')),
    Key([mod], "x", lazy.shutdown()),
    Key([mod], "u", lazy.spawn(home + '/.config/qtile/scripts/rdesktop.sh')),
    Key([mod], "s", lazy.spawn('alacritty -e ' + home + '/.local/bin/spoty')),

    # SUPER + SHIFT KEYS

    Key([mod, "shift"], "Return", lazy.spawn('pcmanfm')),
    # Key([mod, "shift"], "d", lazy.spawn(
    #     "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")),
    # Key([mod, "shift"], "d", lazy.spawn(
    #     home + '/.config/qtile/scripts/dmenu.sh')),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "g", lazy.spawn(
        'xrandr -s 1920x1080'), lazy.restart()),
    Key([mod, "shift"], "g", lazy.spawn(
        'xrandr -s 3440x1440'), lazy.restart()),
    Key([mod, "shift"], "x", lazy.shutdown()),
    Key([mod, "shift"], "w", lazy.spawn(
        home + '/.config/qtile/scripts/pywal-colors-fav.py')),

    # CONTROL + ALT KEYS

    Key(["mod1", "control"], "c", lazy.spawn('catfish')),
    Key(["mod1", "control"], "i", lazy.spawn('nitrogen')),
    Key(["mod1", "control"], "o", lazy.spawn(
        home + '/.config/qtile/scripts/picom-toggle.sh')),
    Key(["mod1", "control"], "a", lazy.spawn('alacritty')),
    Key(["mod1", "control"], "t", lazy.spawn('termite')),
    Key(["mod1", "control"], "u", lazy.spawn('pavucontrol')),
    Key(["mod1", "control"], "Return", lazy.spawn('termite')),

    # ALT + ... KEYS


    Key(["mod1"], "p", lazy.spawn('pamac-manager')),
    Key(["mod1"], "f", lazy.spawn('google-chrome-stable')),
    Key(["mod1"], "e", lazy.spawn('emacs')),
    Key(["mod1"], "m", lazy.spawn('thunar')),
    Key(["mod1"], "w", lazy.spawn('garuda-welcome')),


    # CONTROL + SHIFT KEYS

    Key([mod2, "shift"], "Escape", lazy.spawn('lxtask')),

    # SCREENSHOTS

    Key([], "Print", lazy.spawn('flameshot full -p ' + home + '/Imágenes')),
    Key([mod2], "Print", lazy.spawn('flameshot full -p ' + home + '/Imágenes')),
    #    Key([mod2, "shift"], "Print", lazy.spawn('gnome-screenshot -i')),

    # MULTIMEDIA KEYS

    # INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),

    # INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

    #    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    #    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
    #    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
    #    Key([], "XF86AudioStop", lazy.spawn("mpc stop")),

    # QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "space", lazy.next_layout()),

    # CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),


    # RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),


    # FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod, "shift"], "f", lazy.layout.flip()),

    # FLIP LAYOUT FOR BSP
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),

    # MOVE WINDOWS UP OR DOWN BSP LAYOUT
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

    # Treetab controls
    Key([mod, "control"], "k",
        lazy.layout.section_up(),
        desc='Move up a section in treetab'
        ),
    Key([mod, "control"], "j",
        lazy.layout.section_down(),
        desc='Move down a section in treetab'
        ),



    # MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),

    # TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "space", lazy.window.toggle_floating()), ]

groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", ]
# group_names =  [("1", {'layout': 'tile', 'matches':[Match(wm_class=["Google-chrome"])]}),
#                 ("2", {'layout': 'monadtall'}),
#                 ("3", {'layout': 'ratiotile'}),
#                 ("4", {'layout': 'max'}),
#                 ("5", {'layout': 'max'}),
#                 ("6", {'layout': 'monadtall', 'matches':[Match(wm_class=["Pcmanfm"])]}),
#                 ("7", {'layout': 'max'})
#                 ]

# FOR AZERTY KEYBOARDS
#group_names = ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave",]

#group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9 ", "0",]
group_labels = ["  ", "  ", "  ", "  ", "  ", "  ", "  ", ]
#group_labels = ["Web", "Edit/chat", "Image", "Gimp", "Meld", "Video", "Vb", "Files", "Mail", "Music",]

group_layouts = ["tile", "monadtall", "ratiotile",
                 "floating", "max", "monadtall", "max", ]

# group_matches = [[Match(wm_class=["Google-chrome", "LibreWolf"])],
group_matches = ["None",
                 "None",
                 [Match(wm_class=["Virt-manager"])],
                 "None",
                 "None",
                 "None",
                 [Match(wm_class=["rdesktop"])],
                 ]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
            matches=group_matches[i],
        ))

for i in groups:
    keys.extend([

        # CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        Key(["mod1"], "Tab", lazy.screen.next_group()),
        Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),
        Key(["mod1"], "Left", lazy.screen.prev_group()),
        Key(["mod1"], "Right", lazy.screen.next_group()),

        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        #Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(
            i.name), lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {"margin": 12,
            "border_width": 2,
            "border_focus": "#9BDD22",
            "border_normal": "#c0c5ce",
            "grow_amount": 5
            }


layout_theme = init_layout_theme()


layouts = [
    layout.MonadTall(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(fancy=True, **layout_theme),
    layout.Max(**layout_theme),
    layout.Tile(add_on_top=False, add_after_last=True,
                ratio=0.68, **layout_theme),
    layout.Zoomy(**layout_theme)
]

# COLORS FOR THE BAR


# def init_colors():
#     return [["#2F343F", "#2F343F"],  # color 0
#             ["#2F343F", "#2F343F"],  # color 1
#             ["#c0c5ce", "#c0c5ce"],  # color 2
#             ["#ff4500", "#ff4500"],  # color 3
#             ["#3384d0", "#3384d0"],  # color 4
#             ["#ffffff", "#ffffff"],  # color 5
#             ["#ff0000", "#ff0000"],  # color 6
#             ["#9BDD22", "#9BDD22"],  # color 7
#             ["#151515", "#151515"],  # color 8
#             ["#9400de", "#9400de"]]  # color 9

##### Import Pywal Palette / Importar la paleta generada por pywal #####
with open(home + '/.cache/wal/colors.json') as json_file:
    data = json.load(json_file)
    colorsarray = data['colors']
    val_list = list(colorsarray.values())
    def getList(val_list):
        return [*val_list]

def init_colors():
    return [*val_list]


colors = init_colors()

# WIDGETS FOR THE BAR


def init_widgets_defaults():
    return dict(font="MesloLGSDZ Nerd Font",
                fontsize=18,
                padding=2,
                fontshadow='#000000',
                background=colors[1])


widget_defaults = init_widgets_defaults()


def init_widgets_list():
    widgets_list = [
                #### Shortcuts ####
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    text="",
                    # mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('rofi -theme "~/.config/rofi/launcher.rasi" -show drun')},
                    fontshadow=colors[3]
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    text="",
                    # mouse_callbacks={'Button1': wsearx},
                    fontshadow=colors[3]
                    ),        
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    text="",
                    # mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(term)},
                    fontshadow=colors[3]
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    text="",
                    # mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('nautilus')},
                    fontshadow=colors[3]
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    text="",
                    # mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('/opt/bin/genwal')},
                    fontshadow=colors[3]
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    text="",
                    # mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('/opt/bin/shortc')},
                    fontshadow=colors[3]
                    ),
                widget.TextBox(
                    foreground=colors[1],
                    text="◢",
                    fontsize=45,
                    padding=-2
                    ),
                #### Groups ####
                widget.GroupBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    disable_drag=True,
                    hide_unused=False,
                    fontshadow=colors[0],
                    margin_y=1,
                    padding_x=5,
                    borderwidth=0,
                    active=colors[7],
                    inactive=colors[1],
                    rounded=False,
                    highlight_method="text",
                    this_current_screen_border=colors[0],
                    this_screen_border=colors[3],
                    other_current_screen_border=colors[0],
                    other_screen_border=colors[0],
                    foreground=colors[2],
                    background=colors[1]
                    ),
                #### Notification ####
                widget.Prompt(
                    # prompt = prompt,
                    foreground=colors[0],
                    background = colors[1]
                    ),
                widget.TextBox(
                    background=colors[0],
                    foreground=colors[1],
                    text="◤",
                    fontsize=45,
                    padding=-2
                    ),
                #### Window Name ####    
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    fontshadow=colors[4],
                    text=""
                    ),
                widget.WindowName(
                    foreground=colors[7],
                    background=colors[0],
                    padding=5,
                    format='{name}',
                    empty_group_string='QARSlp',
                    max_chars=45
                    ),
                widget.Notify(
                    default_timeout=15,
                    foreground_urgent=colors[7],
                    foreground=colors[7],
                    background=colors[0]
                    ),
                #### Spacer ####
                widget.Spacer(
                    length=bar.STRETCH,
                    background=colors[0],
                    foreground=colors[0]
                    ),   
                #### Spotify ####
                widget.TextBox(
                    text="◢",
                    background=colors[0],
                    foreground=colors[6],
                    padding=-2,
                    fontsize=45
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,text="",
                    padding=5,
                    foreground=colors[0],
                    background=colors[6],
                    fontshadow=colors[7],
                    # mouse_callbacks={'Button1': ncsp}
                    ),
                widget.Mpris2(
                    name='ncspot',
                    objname='org.mpris.MediaPlayer2.ncspot',
                    scroll_chars=25,
                    background=colors[6],
                    foreground=colors[0],
                    stop_pause_text='',
                    display_metadata=['xesam:artist','xesam:title'],
                    scroll_interval=0.5,
                    scroll_wait_intervals=1000
                    ),
                #### Layouts ####
                widget.TextBox(
                    text="◢",
                    background=colors[6],
                    foreground=colors[2],
                    padding=-2,
                    fontsize=45
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    background=colors[2],
                    foreground=colors[0],
                    fontshadow=colors[7],
                    text=""
                    ),
                widget.CurrentLayout(
                    background=colors[2],
                    foreground=colors[0]
                    ),
                #### Pomodoro ####
                widget.TextBox(
                    text='◢',
                    background=colors[2],
                    foreground=colors[5],
                    padding=-2,
                    fontsize=45
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    background=colors[5],
                    foreground=colors[0],
                    text="",
                    fontshadow=colors[7]
                    ),
                widget.Pomodoro(
                    background=colors[5],
                    foreground=colors[0],
                    color_active=colors[0],
                    color_break=colors[2],
                    color_inactive=colors[0],
                    length_pomodori=50,
                    length_short_break=5,
                    length_long_break=15,
                    num_pomodori=3,
                    prefix_break='Break',
                    prefix_inactive='start',
                    prefix_long_break='Long Break',
                    prefix_paused=''
                    ),
                #### Updates ####
                widget.TextBox(
                    text='◢',
                    background=colors[5],
                    foreground=colors[3],
                    padding=-2,
                    fontsize=45
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    background=colors[3],
                    foreground=colors[0],
                    fontshadow=colors[7],
                    text=" ",
                    ), 
                widget.CheckUpdates(
                    update_interval=1800,
                    distro='Arch_checkupdates',
                    foreground=colors[0],
                    # mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(term + ' -e sudo pacman -Syu')},
                    display_format="{updates} updates",
                    background=colors[3],
                    colour_have_updates=colors[0],
                    colour_no_updates=colors[0]
                    ),
                #### Khal Calendar ####
                #widget.KhalCalendar(lookahead=15, remindertime=60, foreground=colors[0], background=colors[7]),
                #### Sound Control ####
                widget.TextBox(
                    text='◢',
                    background=colors[3],
                    foreground=colors[7],
                    padding=-2,
                    fontsize=45
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    text=" ",
                    foreground=colors[0],
                    background=colors[7],
                    padding=0,
                    fontsize=15,
                    # mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('pavucontrol')},
                    fontshadow=colors[3]
                    ),
                widget.Volume(
                    channel='Master',
                    background=colors[7],
                    foreground=colors[0],
                    fontshadow=colors[7]
                    ),
                #### Date Clock Session Control ####
                widget.TextBox(
                    text='◢',
                    background=colors[7],
                    foreground=colors[0],
                    padding=-2,
                    fontsize=45
                    ),
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    padding=1,
                    text="",
                    fontsize=15,
                    foreground=colors[7],
                    background=colors[0],
                    fontshadow=colors[3]
                    ),
                widget.Clock(
                    foreground=colors[7],
                    background=colors[0],
                    format="%b %a %d -> %H:%M",
                    update_interval=1
                    ),
                #### Lock, Logout, Poweroff ####
                widget.TextBox(
                    font='Font Awesome 5 Free',
                    fontsize=15,
                    foreground=colors[7],
                    text="",
                    # mouse_callbacks={'Button1': wsess},
                    fontshadow=colors[3]
                    ),
    ]
    return widgets_list


widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1


def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2


widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=20, opacity=0.68, background="000000")),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=20, opacity=0.68, background="000000"))]


screens = init_screens()


# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []

# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
# BEGIN

# @hook.subscribe.client_new
# def assign_app_group(client):
#     d = {}
#     #########################################################
#     ################ assgin apps to groups ##################
#     #########################################################
#     d["1"] = ["Navigator", "Firefox", "Vivaldi-stable", "Vivaldi-snapshot", "Chromium", "Google-chrome", "Brave", "Brave-browser",
#               "navigator", "firefox", "vivaldi-stable", "vivaldi-snapshot", "chromium", "google-chrome", "brave", "brave-browser", ]
#     d["2"] = [ "Atom", "Subl3", "Geany", "Brackets", "Code-oss", "Code", "TelegramDesktop", "Discord",
#                "atom", "subl3", "geany", "brackets", "code-oss", "code", "telegramDesktop", "discord", ]
#     d["3"] = ["Inkscape", "Nomacs", "Ristretto", "Nitrogen", "Feh",
#               "inkscape", "nomacs", "ristretto", "nitrogen", "feh", ]
#     d["4"] = ["Gimp", "gimp" ]
#     d["5"] = ["Meld", "meld", "org.gnome.meld" "org.gnome.Meld" ]
#     d["6"] = ["Vlc","vlc", "Mpv", "mpv" ]
#     d["7"] = ["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
#               "virtualbox manager", "virtualbox machine", "vmplayer", ]
#     d["8"] = ["pcmanfm", "Nemo", "Caja", "Nautilus", "org.gnome.Nautilus", "Pcmanfm", "Pcmanfm-qt",
#               "pcmanfm", "nemo", "caja", "nautilus", "org.gnome.nautilus", "pcmanfm", "pcmanfm-qt", ]
#     d["9"] = ["Evolution", "Geary", "Mail", "Thunderbird",
#               "evolution", "geary", "mail", "thunderbird" ]
#     d["0"] = ["Spotify", "Pragha", "Clementine", "Deadbeef", "Audacious",
#               "spotify", "pragha", "clementine", "deadbeef", "audacious" ]
#     ##########################################################
#     wm_class = client.window.get_wm_class()[0]

#     for i in range(len(d)):
#         if wm_class in list(d.values())[i]:
#             group = list(d.keys())[i]
#             client.togroup(group)
#             client.group.cmd_toscreen()

# END
# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME


main = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])


@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])


@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True


floating_types = ["notification", "toolbar", "splash", "dialog"]


follow_mouse_focus = False
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},
    {'wmclass': 'makebranch'},
    {'wmclass': 'maketag'},
    {'wmclass': 'Arandr'},
    {'wmclass': 'feh'},
    {'wmclass': 'Galculator'},
    {'wname': 'branchdialog'},
    {'wname': 'Open File'},
    {'wname': 'pinentry'},
    {'wmclass': 'ssh-askpass'},
    {'wmclass': 'lxpolkit'},
    {'wmclass': 'Lxpolkit'},
    {'wmclass': 'yad'},
    {'wmclass': 'Yad'},
    {'wmclass': 'Pamac-manager'},
    {'wmclass': 'Mailspring'},
    {'wmclass': 'Spotify'},
    {'wmclass': 'Gpick'},
    {'wmclass': 'ocs-url'},
    {'wname': 'Imagen en imagen'},
    {'wname': 'Calendar'},


],  fullscreen_border_width=0, border_width=0)
auto_fullscreen = True

focus_on_window_activation = "focus"  # or smart

wmname = "LG3D"
