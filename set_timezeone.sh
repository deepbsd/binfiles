#!/usr/bin/env bash

timezones=()
for timezone in $(timedatectl list-timezones); do
    #timezones+=( "$timezone" "$(basename $timezone)" )
    timezones+=( $(printf "%s\t\t%s\n" $timezone 'timezone') )
done

backmessage="CHOOSE YOUR TIMEZONE"
message="Please choose your timezone"

timezone=$(eval `resize`; whiptail --backtitle "$backmessage" --title "$message" \
    --menu "Here are your timezones:" $LINES $COLUMNS $(( $LINES - 8 )) "${timezones[@]}"  3>&1 1>&2 2>&3)


#timezone=$(eval `resize`; whiptail --backtitle "CHOOSE KEYMAP" --title "Choose Keyboard Map"  \
#    --menu "Default is us keymap" $LINES $COLUMNS $(( $LINES - 8 )) "${options[@]}" 3>&1 1>&2 2>&3 )

echo $timezone
