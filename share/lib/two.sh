#!/usr/bin/env bash

# snarf the variables
source $mypath/one.sh

# construct another variable from the snarfed variables
line="My name is $NAME and I live in $CITY, $STATE, which is in $COUNTY, County $STATE."


# Construct a function from the constructed variable
sayline(){
    echo $line
}
