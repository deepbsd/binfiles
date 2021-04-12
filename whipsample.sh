#!/usr/bin/env bash

showcolor(){
    color=$1
    message=$(echo "You chose $color") 
    whiptail --msgbox --title "Your color choice" "$message" 10 30
}

greeter(){
    name=$1
    message=$(echo "Greetings $name!")
    whiptail --msgbox --title "Greetings" "$message" 10 30
}

showinfo(){
    info=$1
    whiptail --title "Here's an Infobox" --infobox "Here's an infobox example" 10 30 
}

choosecolor(){
    while true; do
        choice=$(
        whiptail --title "Choose a color" --menu "Your favorite color" 16 80 9 \
            "1)"    "red"  \
            "2)"    "blue"  \
            "3)"    "green"  \
            "4)"    "white"  \
            "5)"    "main menu"  3>&2 2>&1 1>&3
        )
        case $choice in
            "1)" ) showcolor "red" ;;
            "2)" ) showcolor "blue" ;;
            "3)" ) showcolor "green" ;;
            "4)" ) showcolor "white" ;;
            "5)" ) mainmenu ;;
        esac
    done
}

getname(){
    name=$(whiptail --inputbox "What is your name?" 8 39 --title "Testing Inputbox" 3>&1 1>&2 2>&3)
    greeter $name
}

mainmenu(){

    while true; do
        choice=$(
        whiptail --title "What shall we do?" --menu "Your choices" 16 80 9 \
            "1"    "inputbox sample"  \
            "2"    "menu sample"      \
            "3"    "infobox sample"      \
            "X"    "Exit"  3>&2 2>&1 1>&3
        )
        case $choice in 
            "1")    getname ;;
            "2")    choosecolor ;;
            "3")    showinfo ;;
            "X")    echo "Bye for now!" && exit 0 ;;
            "*")    echo "Please choose valid option." ;;
        esac
    done
}

mainmenu
