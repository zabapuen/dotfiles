#!/usr/bin/env sh

if pgrep trayer ;
then
  killall trayer
fi

trayer --edge top \
    --align center \
    --distancefrom top \
    --distance 15 \
    --widthtype request \
    --padding 3 \
    --iconspacing 10 \
    --expand true \
    --monitor 0 \
    --transparent true \
    --alpha 255 \
    --tint 0x0D0D0D \
    --height 30 \
    &

# trayer --edge top \
#     --align center \
#     --distance 15 \
#     --widthtype pixel \
#     --width 200 \
#     --transparent true \
#     --alpha 0 \
#     --tint 0x0D0D0D \
#     --height 30 \
#     &
