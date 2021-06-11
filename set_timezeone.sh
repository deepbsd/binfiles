#!/usr/bin/env bash

timezones=()
for timezone in $(timedatectl list-timezones); do
    #timezones+=( "$timezone" "$(basename $timezone)" )
    timezones+=( $(printf "%s\t\t%s\n" $timezone "$timezone timezone") )
done

backmessage="CHOOSE YOUR TIMEZONE"
message="Please choose your timezone"
timezone=$(eval `resize`; whiptail --backtitle $backmessage --title $message --menu "Here are your timezones:" "${timezones[@]}" $LINES $COLUMNS $(( LINES - 8 )) 3>&1 1>&2 2>&3)

echo $timezone
