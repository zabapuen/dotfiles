#!/usr/bin/env sh
if pgrep -x "nwgbar" > /dev/null
then
	killall nwgbar
else
	nwgbar -b #03070b
fi
