#!/usr/bin/env bash

# Some monitors don't play nicely with various Linux distros.  One of my monitors has been a
# repeat offender.  I must manually add the Modeline for that monitor using xrandr, and I
# keep some notes on how to do that in my binfiles repo

# xrandr --newmode "1920x1080X"  325.08  1920 1944 1976 2056  1080 1083 1088 1098 +hsync +vsync

# xrandr --addmode DisplayPort-1 1920x1080X

#xrandr --output DisplayPort-1 --mode 1920x1080X

# 1920x1080 143.88 Hz (CVT) hsync: 169.35 kHz; pclk: 452.50 MHz
xrandr --newmode "1920x1080_144"  452.50  1920 2088 2296 2672  1080 1083 1088 1177 -hsync +vsync

xrandr --addmode DisplayPort-1 1920x1080_144

xrandr --output DisplayPort-1 --mode 1920x1080_144

#  Put in /usr/share/X11/xorg.conf.d/10-monitor.conf  (uncomment first)

#Section "Monitor"
#    Identifier "DisplayPort-1"
#    Modeline "1920x1080X"   325.08  1920 1944 1976 2056  1080 1083 1088 1098 +hsync +vsync
#    Option "PreferredMode" "1920x1080X"
#EndSection
