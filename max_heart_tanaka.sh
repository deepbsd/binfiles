#!/usr/bin/env bash

clear
echo -e "\n\n\t\t###############################################\n\t\tWelcome to The Tanaka Age-Based MaxHR Predictor\n\t\t###############################################\n\n"

echo -e "\tThis script will calculate your MaxHR based on your age and then"
echo -e "\tcalculate your HR Zones based on that MaxHR, or give you the chance to"
echo -e "\tprovide your own MaxHR based on observation and then calculate HR Zones "
echo -e "\ton that provided number.\n\n\n\n"


echo "How old are you?"
read age

factor=$(echo "0.7*$age" | bc)
factor=${factor%.*}     # remove trailing decimal
max_hr=$(echo -e "208-$factor" | bc)

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
fi



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
