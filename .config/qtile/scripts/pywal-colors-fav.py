#!/usr/bin/env python
import os
import random
wallpaper_list = []

h = os.environ.get('HOME')
w = "/.local/share/wallpapers/favs"
e = h + w

for path in os.listdir(e):
   full_path = os.path.join(e, path)
   if os.path.isfile(full_path):
       wallpaper_list.append(full_path)

wallpaper = random.choice(wallpaper_list)

os.system("wal -i " + wallpaper + " -n ")
os.system("feh --bg-fill " + wallpaper)

print(wallpaper_list)