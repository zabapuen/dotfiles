#!/usr/bin/env python
import os
import random
wallpaper_list = []

#Add your own wallpapers directory
wall_path = "/.local/share/wallpapers"
e = os.environ.get('HOME') + wall_path
for path in os.listdir(e):
   full_path = os.path.join(e, path)
   if os.path.isfile(full_path):
       wallpaper_list.append(full_path)

wallpaper = random.choice(wallpaper_list)

os.system("wal -i " + wallpaper)

print(wallpaper_list)
