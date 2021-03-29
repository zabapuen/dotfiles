#!/usr/bin/env python
import os
import random
wallpaper_list = []

h = os.environ.get('HOME')
w = "/.local/share/wallpapers"
w2 = "/Imágenes/Walls/Anime/Summer"
e = h + w2

#Add your own wallpapers directory
e = "/home/alejandro/.local/share/wallpapers/favs"
for path in os.listdir(e):
   full_path = os.path.join(e, path)
   if os.path.isfile(full_path):
       wallpaper_list.append(full_path)

wallpaper = random.choice(wallpaper_list)

os.system("wal -i " + wallpaper + " -n ")
os.system("feh --bg-fill " + wallpaper)

print(wallpaper_list)