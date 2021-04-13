#!/usr/bin/env bash

exitapp(){
    if (whiptail --title "Yes-No Dialog" --yesno "Ready to exit whipsample?" 8 78); then
        echo "Thanks for playing!"
        exit 0
    else
        # Note that the 'calling function' is *this* function, because the infobox is
        # spawned inside parens
        (TERM=ansi whiptail --title "Infobox" --infobox "Okay, sending you back to main menu..." 8 75)
        sleep 5
        mainmenu
    fi
}

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

showchoices(){
    choices=$1
    whiptail --msgbox --title "You chose: " "$choices" 10 30
}

callshowinfo(){
    showinfo 
    sleep 10 
    mainmenu
}

showinfo(){
    message="An infobox disappears immediately when the calling shell script is complete.\n\nYou use it to show a panel until a process completes.\n\nOtherwise, you can use a --msgbox \n\nIn this example, we're waiting for 10 seconds."
    TERM=ansi whiptail --title "Here's an Infobox" --infobox "$message" 20 70 
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

callchecklist(){
    # user can select more than one option
    selections=$(whiptail --title "Linux Distros" --checklist \
        "What are distros you have tried? " 20 38 10 \
        "Arch Linux"  "" OFF \
        "Ubuntu"  "" OFF \
        "Debian"  "" OFF \
        "Red Hat/Fedora"  "" OFF \
        "OpenSuse"  "" OFF \
        "Solus"  "" OFF \
        "Antix/MX"  "" OFF \
        "PopOS"  "" OFF \
        "EndeavourOS"  "" OFF \
        "Linux Mint"  "" OFF 3>&2 2>&1 1>&3)

    showchoices "$selections"
}

callradiolist(){
    # user can only select only ONE option
    selection=$(whiptail --title "Linux Distros" --radiolist \
        "What is your favorite distro? (Can only chose ONE)" 20 48 10 \
        "Arch Linux" "" OFF \
        "Ubuntu"  "" OFF \
        "Linux Mint" "" OFF \
        "Debian" "" OFF \
        "Red Hat/Fedora" "" OFF \
        "OpenSUSE" "" OFF \
        "Solus" "" OFF \
        "Antix/MX" "" OFF \
        "PopOS" "" OFF \
        "EndeavourOS" "" OFF 3>&2 2>&1 1>&3 )

    showchoices "$selection"
}

calltextbox(){
    info=$(lsb_release -a)
    host=$(hostname)
    echo "Welcome to $host running $info!" > ~/tmp/testtxtbox
    whiptail --textbox ~/tmp/testtxtbox  20 70
}

callpasswordbox(){
    secret='rtfm'
    guessed=$(whiptail --passwordbox "Please enter your password: " 8 75 --title "Password Dialog" 3>&1 1>&2 2>&3)
    if [[ "$secret" == "$guessed" ]]; then
        showcolor "Yay! You guessed the secret!"
    else
        showcolor "Sorry, you did NOT guess the password!"
    fi
}

callprogressgauge(){
    { for (( i=0; i<=100; i+=5 )); do
        sleep 0.5
        echo $i
    done
    } | whiptail --gauge "Please wait..." 6 50 0

    mainmenu
}

mainmenu(){

    while true; do
        choice=$(
        whiptail --title "What shall we do?" --menu "Your choices" 16 80 9 \
            "I"    "inputbox sample"  \
            "M"    "menu sample"      \
            "F"    "infobox sample"   \
            "C"    "checklist sample"   \
            "R"    "radiolist sample"   \
            "T"    "textbox sample"   \
            "P"    "passwordbox sample"   \
            "G"    "progress gauge sample" \
            "X"    "Exit (Yes/No box)"  3>&2 2>&1 1>&3
        )
        case $choice in 
            "I")    getname ;;
            "M")    choosecolor ;;
            "F")    callshowinfo ;;
            "C")    callchecklist ;;
            "R")    callradiolist ;;
            "X")    exitapp ;;
            "T")    calltextbox ;;
            "P")    callpasswordbox ;;
            "G")    callprogressgauge ;;
            "*")    (whiptail --title "Please make valid choice" --msgbox "Please make a valid choice.  Hit OK to continue" 8 75 ) ;;
        esac
    done
}

mainmenu
