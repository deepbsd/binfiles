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

calculate(){
    num=1
    limit=240  # 2 minute loop
    ## remove stale logfiles
    [[ -f logfile ]] && rm logfile
    while [[ $num -lt $limit ]]; do
        date +"%D-->%H:%M:%S::%N" &>>logfile
        echo "Num: $num"  &>>logfile
        sleep 1
        num=$(( num+1 ))
    done
    echo "=== Done ===" &>>logfile
}

# Original idea for show progress. 
showprogress(){
    case $1 in
        'b') arr=( 0 5 10 20 25 ) ;;
        'm') arr=( 35 45 55 65 ) ;;
        'e') arr=( 77 88 95 98 99 ) ;;
          *) arr=()
    esac

    for n in "${arr[@]}"; do
        echo $n
        sleep 3
    done

    [[ $1 == 'e' ]] && echo 100 && sleep 5
}

# Later idea for show progress.  Little better
# Basically the 2nd parameter IS the length of time in seconds
showprogress1(){
    start=$1; end=$2; shortest=$3; longest=$4

    for n in $(seq $start $end); do
        echo $n
        pause=$(shuf -i ${shortest:=1}-${longest:=3} -n 1)  # random wait between 1 and 3 seconds
        sleep $pause
    done
}

specialprogressgauge1(){
    calculate &
    thepid=$!
    num=0
    echo "thepid: $thepid"  
    while true; do
        if $(ps aux|grep "$thepid" &>/dev/null); then
            echo "PID: $thepid" &>>logfile
            num=$(( num + 1 ))
            sleep 0.1
        else
            num=100
            sleep 2
            break
        fi
        [[ $num -gt 100 ]] && break
        echo $num
    done  | whiptail --title "Progress Gauge" --gauge "Calculating stuff" 6 70 0 
}

specialprogressgauge(){
    calculate&
    thepid=$!
    while true; do
        showprogress1 1 65
        sleep 2
        num=66
        while $(ps aux | grep -v 'grep' | grep "$thepid" &>/dev/null); do
            echo $num 
            if [[ $num -gt 77 ]] ; then num=$(( num-3 )); fi
            sleep 5
            num=$(( num+1 ))
        done
        showprogress1 $num 100 0.1 1
        break
    done  | whiptail --title "Progress Gauge" --gauge "Calculating stuff" 6 70 0
}

mainmenu(){

    while true; do
        choice=$(
        whiptail --backtitle "Whiptail Examples" --title "What shall we do?" --menu "Your choices" 22 80 12 \
            "I"    "inputbox sample   (with msgbox sample)"  \
            "M"    "menu sample"      \
            "F"    "infobox sample"   \
            "C"    "checklist sample"   \
            "R"    "radiolist sample"   \
            "T"    "textbox sample"   \
            "P"    "passwordbox sample"   \
            "G"    "progress gauge sample" \
            "S"    "progress gauge 'special'" \
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
            "S")    specialprogressgauge ;;
            "*")    (whiptail --title "Please make valid choice" --msgbox "Please make a valid choice.  Hit OK to continue" 8 75 ) ;;
        esac
    done
}

mainmenu
