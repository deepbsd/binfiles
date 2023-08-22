#!/usr/bin/env bash

# NOTE:  This script updates Archlinux hosts designated
# from hosts in a hosts_file (hosts.txt) in the users 
# home directory

######### Variables  ################

hosts_file=$HOME/hosts.txt
[ -z $hosts_file  ] && echo "No Hosts file!" && exit 1

declare -a hosts
hosts=( $(cat $hosts_file) )
echo -n 'What is your sudo user password?   '
read passwd


######  Functions  ###################

identify(){    # Get the users credentials

    if pgrep ssh-agent ; then
        echo continuing...
    else
        eval $(ssh-agent)
    fi
    ssh-add
}


update_host(){     # Run the actual update on each host in the file

    for h in "${hosts[@]}"; do

        echo "HOST: $h"

        if [ ! `cat /etc/hostname` == "$h" ]; then
            ssh "$h.lan"  echo "$passwd" | sudo -S pacman --noconfirm -Syyu
        else
            echo "$passwd" | sudo -S pacman --noconfirm -Syyu
        fi

    done
}



main(){
    identify
    update_host
}


### MAIN ###
main

