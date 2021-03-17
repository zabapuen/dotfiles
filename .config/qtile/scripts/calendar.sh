#!/bin/bash
if pgrep -x "galendae" > /dev/null
then
	killall galendae
else
	galendae
fi
