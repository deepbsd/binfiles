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
    options+=( $(printf "%s\t%s\t%s\n" $newfile \"====\" $status)  )
    #options+=( $(printf "%s\t%s\n" $newfile '=====')  )
done

#echo "number: ${#options[@]}"

#for line in "${options[@]}"; do
#    echo $line
#done

options=( "${options[@]:0:20}" )

selection=$(eval `resize`; whiptail --title "Choose Keyboard Map" --radiolist "Default is us keymap" \
    30 80 $(("${#options[@]}")) "${options[@]}" 3>&1 1>&2 2>&3 )

echo "Your keymap is ${selection:-'howdie folks!'}"
