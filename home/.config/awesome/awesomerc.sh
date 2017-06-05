#!/bin/bash

runonce ()
{
  pgrep `basename $1` || "$@" &
}


setxkbmap us altgr-intl

CONNECTED_SCREENS="$(xrandr -q | awk '/\<connected\>/ {print $1}' )"

for S in $CONNECTED_SCREENS
do
   XRANDR_OPT="$XRANDR_OPT --output $S --auto"
   if [ -n "$LAST_SCREEN" ];then
     XRANDR_OPT="$XRANDR_OPT --right-of $LAST_SCREEN "
   fi
   LAST_SCREEN="$S"
done

xrandr $XRANDR_OPT

# wicd-gtk -t &

#?# NUM_PULSE_PKG=$(dpkg -l |grep -c ^ii.*pulse) 
#?# if [ $NUM_PULSE_PKG -gt 3 ];then
#?#         zenity --error --text "Achtung, wir haben <b>$NUM_PULSE_PKG packages</b> with <i>pulse</i> in the name...\nIf you like music, maybe you'd apt-get purge 'em"
#?# 
#?# fi

runonce /home/ssehier/bin/fdpowermon0
runonce /home/ssehier/bin/fdpowermon1
runonce xfce4-clipman
#runonce icedove
#runonce iceweasel
#runonce pidgin
runonce nm-applet
runonce pasystray -a
# Let screen launch icedove and co:
pgrep screen || x-terminal-emulator -e screen -U -c ~/.screenrc.awesome &


