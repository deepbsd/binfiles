#!/usr/bin/env bash

keymaps=$(find /usr/share/kbd/keymaps/ -type f -printf "%f\n" | sort -V)

keymaps=( $keymaps )

status=""
options=()

echo "keymaps: ${#keymaps[@]}"

for file in "${keymaps[@]}"; do
    if [[ "${file%%.*}" == 'us' ]]; then
        status="ON"
    else
        status="OFF"
    fi

    newfile=$( echo $file | sed 's/.map.gz//g' )
    #options+=( $(printf "%s\t%s\t%s\n" $newfile \"====\" $status)  )
    options+=( $(printf "%s\t%s\n" $newfile '=====')  )
done

#options=( "${options[@]:0:90}" )

length="${#options[@]}"

echo "Length: $length"

for line in "${options[@]}"; do
    echo $line
done

selection=$(eval `resize`; whiptail --backtitle "CHOOSE KEYMAP" --title "Choose Keyboard Map"  \
    --menu "Default is us keymap" $LINES $COLUMNS $(( $LINES - 8 )) "${options[@]}" 3>&1 1>&2 2>&3 )

echo "Your keymap is ${selection:-'howdie folks!'}"
