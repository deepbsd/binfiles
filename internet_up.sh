#!/usr/bin/env bash

INTERVAL=30
clear
echo "Do we have Internet yet here at the house:  "
while [[ ! $( ping -c 3 www.sourceforge.net 2>/dev/null )  ]] ; do
    echo -n '.'
    sleep 60
done

echo "INTERNET IS BACK UP!!"
date
