#!/bin/bash
if pgrep -x "nwgbar" > /dev/null
then
	killall nwgbar
else
	nwgbar
fi
