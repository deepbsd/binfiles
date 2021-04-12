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
    whiptail --msgbox --title "Your choices are: " "$choices" 10 30
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
    selections=$(whiptail --title "Sundae Toppings" --checklist \
        "Choose toppings for your sundae: " 20 78 6 \
        "nuts"  "nuts1" ON \
        "whipped cream"  "whipped cream2" ON \
        "chocolate syrup"  "chocolate syrup3" ON 3>&2 2>&1 1>&3)

    showchoices "$selections"
}

mainmenu(){

    while true; do
        choice=$(
        whiptail --title "What shall we do?" --menu "Your choices" 16 80 9 \
            "1"    "inputbox sample"  \
            "2"    "menu sample"      \
            "3"    "infobox sample"   \
            "4"    "checklist sample"   \
            "X"    "Exit"  3>&2 2>&1 1>&3
        )
        case $choice in 
            "1")    getname ;;
            "2")    choosecolor ;;
            "3")    callshowinfo ;;
            "4")    callchecklist ;;
            "X")    exitapp ;;
            "*")    echo "Please choose valid option." ;;
        esac
    done
}

mainmenu
