#!/bin/bash
if pgrep -x "shutdown-dialog" > /dev/null
then
	killall shutdown-dialog
else
	shutdown-dialog
fi
