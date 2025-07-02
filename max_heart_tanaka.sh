#!/usr/bin/env bash

age=0
factor=0
max_hr=0

show_intro(){
    intro_message="This script will calculate your MaxHR based on your age and then calculate your HR Zones based on that MaxHR, or you may provide your own observed MaxHR and then calculated HR Zones on that number."

    TERM=ansi whiptail --title "Tanaka Method of HR Max Calculation" --msgbox "$intro_message" 13 78
}

get_age(){
    echo "How old are you?"
    read age
    export age
}

calc_max(){
    export factor=$(echo "0.7*$age" | bc)
    export factor=${factor%.*}     # remove trailing decimal
    export max_hr=$(echo -e "208-$factor" | bc)
}


show_max(){
    echo -e "\nYour max heart rate is $max_hr\n"
    echo -e "\nDo you accept this max hr?\n"
    read accept
    if [[ "$accept" =~ [yY] ]] ; then 
        continue
    else
        # if user did not accept MaxHR then newhr equals Tanaka
        # estimate
        echo -e "\nWhat is your Max HR?\n"
        read newhr
        max_hr=$newhr
        export max_hr
    fi
}

show_zones(){
    echo -e "\nHere are your zones: \n"
    Ninetypct=$(echo "scale=2; $max_hr*0.9" | bc)
    Eightypct=$(echo "scale=2; $max_hr*0.8" | bc)
    Seventypct=$(echo "scale=2; $max_hr*0.7" | bc)
    Sixtypct=$(echo "scale=2; $max_hr*0.6" | bc)
    Fiftypct=$(echo "scale=2; $max_hr*0.5" | bc)
    echo "Zone 5:  $Ninetypct - $max_hr"
    echo "Zone 4:  $Eightypct - $Ninetypct"
    echo "Zone 3:  $Seventypct - $Eightypct"
    echo "Zone 2:  $Sixtypct - $Seventypct"
    echo "Zone 1:  $Fiftypct - $Sixtypct"
}

main(){
    show_intro
    get_age
    calc_max
    show_max
    show_zones
}


####  MAIN  ###

main
