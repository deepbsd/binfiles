#!/usr/bin/env bash


echo "How old are you?"
read age

factor=$(echo "0.7*$age" | bc)
factor=${factor%.*}     # remove trailing decimal
max_hr=$(echo -e "208-$factor" | bc)

echo "Your max heart rate is $max_hr"
