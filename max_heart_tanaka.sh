#!/usr/bin/env bash

echo -e "\n\n##############\nWelcome to The Tanaka Age-Based MaxHR Predictor\n###############\n\n"

echo -e "\nThis script will calculate your MaxHR based on your age and then calculate your HR Zones based on that MaxHR, or give you the chance to provide your own MaxHR based on observation and then calculate HR Zones on that provided number."


echo "How old are you?"
read age

factor=$(echo "0.7*$age" | bc)
factor=${factor%.*}     # remove trailing decimal
max_hr=$(echo -e "208-$factor" | bc)

echo "Your max heart rate is $max_hr"
echo "Do you accept this max hr?"
read accept
if [[ "$accept" =~ [yY] ]] ; then 
    continue
else
    # if user did not accept MaxHR then newhr equals Tanaka
    # estimate
    echo "What is your Max HR?"
    read newhr
    max_hr=$newhr
fi



echo "Here are your zones: "
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
