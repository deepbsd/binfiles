#!/usr/bin/env bash

echo "Welcome to my burger selector!"
echo "Please pick a burger:"

burgers="cheese mushroom buffalo swiss prime-rib"

select option in $burgers; do
   echo "The selected option is $REPLY" 
   echo "The selected meal is $option" 
done
