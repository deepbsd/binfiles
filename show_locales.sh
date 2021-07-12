#!/usr/bin/env bash



locales=()

if $(whiptail --backtitle "KEEP LOCALE?" --title "Want to keep LOCALE as en_US.UTF-8?" --yesno "Yes or No"\
    --yes-button "Keep en_US.UTF-8" --no-button "Change LOCALE" 20 80 3>&1 1>&2 2>&3 ) ; then

    LOCALE=${LOCALE:="en_US.UTF-8"}
else
    # Here's the array of available locales:
    for locale in $(egrep '^#?[a-z]{2}_*' /etc/locale.gen | awk '{print $1}' | sed 's/^#//g'); do
        locale=$( echo $locale | sed 's/ /./g' )
        locales+=( $(printf "%s\t\t%s\n" "$locale" "locale")  )
    done

    # Come up with a whiptail selection menu of all available locales on system
  
    LOCALE=$(eval `resize`; whiptail --backtitle "CHOOSE LOCALE" --title "Choose Your Locale" \
        --menu "Default Locale is en_US.UTF-8" $LINES $COLUMNS $(( $LINES - 8 )) "${locales[@]}" 3>&1 1>&2 2>&3 )
fi

## doublecheck each line
#for line in "${locales[@]}"; do
#    echo $line
#done

echo ${LOCALE:="Have a nice day!"}
