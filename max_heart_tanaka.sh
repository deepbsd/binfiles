#!/usr/bin/env bash

age=0
factor=0
max_hr=0
tmp_file=$HOME/tmp/output_text



show_intro(){
    intro_message="This script will calculate your MaxHR based on your age and then calculate your HR Zones based on that MaxHR, or you may provide your own observed MaxHR and then calculated HR Zones on that number."

    TERM=ansi whiptail --backtitle "Welcome to My Tanaka Shell Script" --title "Tanaka Method of HR Max Calculation" --msgbox "$intro_message" 13 78
}

get_age(){
    age=$(whiptail --inputbox "How old are you?" 8 39 --title "Enter Your Age:" 3>&1 1>&2 2>&3)
    export age
    calc_max
}

calc_max(){
    export factor=$(echo "0.7*$age" | bc)
    export factor=${factor%.*}     # remove trailing decimal
    export max_hr=$(echo -e "208-$factor" | bc)
    show_max
}


show_max(){
    if whiptail --title "Accept this MaxHR or Provide New MaxHR" --yesno "Accept $max_hr as MaxHR or enter new value?" --yes-button "Accept $max_hr as MaxHR" --no-button "Provide New MaxHR" 8 78; then
        max_hr=$max_hr
    else
        # if user did not accept MaxHR then newhr equals Tanaka
        # estimate
        newhr=$(whiptail --inputbox "What is your Observed MaxHR?" 8 39 --title "Input Observed MaxHR" 3>&1 1>&2 2>&3)
        max_hr=$newhr
    fi
    export max_hr
    show_zones
}

show_zones(){
    subtitle="These Are Your HR Training Zones:"
    Ninetypct=$(echo "scale=2; $max_hr*0.9" | bc)
    Eightypct=$(echo "scale=2; $max_hr*0.8" | bc)
    Seventypct=$(echo "scale=2; $max_hr*0.7" | bc)
    Sixtypct=$(echo "scale=2; $max_hr*0.6" | bc)
    Fiftypct=$(echo "scale=2; $max_hr*0.5" | bc)

    echo -e "\t\t$subtitle\n\n\n\t\tZone 5: $Ninetypct - $max_hr \n\t\tZone 4: $Eightypct - $Ninetypct \n\t\tZone 3: $Seventypct - $Eightypct \n\t\tZone 2: $Sixtypct - $Seventypct \n\t\tZone 1: $Fiftypct - $Sixtypct\n" > "$tmp_file"
    TERM=ansi whiptail --backtitle "Showing Your HR Training Zones" --title "Your Training Zones" --textbox $tmp_file 20 50 

}

main_menu(){
    while true; do
        menupick=$(whiptail --title "Main Menu for Tanaka MaxHR and Training Zone Calculator" --menu "Your Choice?" 25 80 16 \
         "Explanation"  "Explain what this program is all about"  \
        "Get Age"   "Enter the User's Age to caclulate Max HR from"  \
        "Show Max HR"  "Show Calculated MaxHR Or Observed Max if applicable"  \
        "Show Zones"   "Show Training Zones from calculated MaxHR"  \
        "Exit"   "Exit this program"  3>&1 1>&2 2>&3 )

        exitstatus=$?

         if [ $exitstatus -ne 0 ]; then
             break
         fi

         case $menupick in
             "Explanation" )
                 show_intro ;;
             "Get Age" )
                 get_age ;;
             "Show Max HR" )
                 calc_max
                 show_max ;;
             "Show Zones" )
                 show_zones ;;
             "Exit" )
                 exit 0 ;;
         esac
     done
}


#main(){
#    show_intro
#    main_menu
#    get_age
#    calc_max
#    show_max
#    show_zones
#}


####  MAIN  ###

main_menu
