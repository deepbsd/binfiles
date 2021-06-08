#!/usr/bin/env bash


LOCALES=()

if $(whiptail --backtitle "KEEP LOCALE?" --title "Want to keep LOCALE as en_US.UTF-8?" \
    --yesno --yes "Keep en_US.UTF-8" --no "Change LOCALE" ); then
    LOCALE=${LOCALE:="en_US.UTF-8"}
else
    # Here's the array of available locales:
    for locale in $(egrep '^#?[a-z]{2}_*' /etc/locale.gen | sed 's/^#//g'); do
        LOCALES+=( $(printf "%s\t\t%s\n" $locale "=======")  )
    done

    # Come up with a whiptail selection menu of all available locales on system

fi

echo "${#LOCALES[@]}"
