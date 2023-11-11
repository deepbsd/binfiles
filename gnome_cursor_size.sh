#!/usr/bin/env bash

default=24
medium=32
large=48
largest=96

size_choice=$default
get_command="gsettings get org.gnome.desktop.interface cursor-size"


show_size(){
    echo "default=$default"
    echo "medium=$medium"
    echo "large=$large"
    echo "largest=$largest"
    eval $get_command
}

set_size(){
    show_size
    echo "What size do you want?"
    read choice
    size_choice="$choice"
    gsettings set org.gnome.desktop.interface cursor-size $size_choice
}

echo -e "Type CTL-C to exit at anytime...\n\n"
set_size
