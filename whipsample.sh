#!/usr/bin/env bash



showcolor(){
    color=$1
    message=$(echo "You chose $color") 
     whiptail --msgbox --title "Your color choice" "$message" 10 30
}














while true; do

choice=$(
whiptail --title "Choose a color" --menu "Your favorite color" 16 100 9 \
    "1)"    "red"  \
    "2)"    "blue"  \
    "3)"    "green"  \
    "4)"    "white"  \
    "5)"    "exit"  3>&2 2>&1 1>&3
)

case $choice in
    "1)" ) showcolor "red" ;;
    "2)" ) showcolor "blue" ;;
    "3)" ) showcolor "green" ;;
    "4)" ) showcolor "white" ;;
    "5)" ) echo "Bye for now!" && exit 0 ;;

esac
done
