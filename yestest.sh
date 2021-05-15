#!/usr/bin/env bash

message=''

if $(whiptail --title "Proceed?" --yesno "Shall we proceed?" 8 50 3>&1 1>&2 2>&3) ; then
    message="Well okay, then.  Away we go."
else
    message="So, okay, let's hold up then."
fi

TERM=ansi whiptail --title "Here's what you chose:" --infobox "$message" 8 50
sleep 5
