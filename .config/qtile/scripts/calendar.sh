#!/usr/bin/env sh
if pgrep -x "galendae" > /dev/null
then
	killall galendae
else
	galendae
fi
