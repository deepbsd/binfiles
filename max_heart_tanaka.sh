#!/usr/bin/env bash


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
    echo "What is your Max HR?"
    read newhr

fi

max_hr=$newhr


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
