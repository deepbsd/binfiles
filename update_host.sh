#!/usr/bin/env bash

# NOTE:  This script updates Archlinux hosts designated
# from hosts in a hosts_file (hosts.txt) in the users 
# home directory

######### Variables  ################

hosts_file=$HOME/bin/hosts.txt
lock_file=/var/lib/pacman/db.lck
[ -f $hosts_file  ] || ( echo "No Hosts file!" && exit 1 )

# populate or clear some variables
declare -a hosts 
locked_hosts=()
hosts=( $(cat $hosts_file) )
arch_hosts=( boomer scee daisy speedy juno peach dixie molly blub milo pumpkin )
deb_hosts=( roscoe omalley )
down_hosts=()



# Get the sudo user password
echo -n 'What is your sudo user password?   '
read passwd


######  Functions  ###################

identify(){    # Get the users credentials

    if pgrep ssh-agent ; then
        echo ssh-agent already running...
    else
        eval "$(ssh-agent -s)"
    fi
    ssh-add ~/.ssh/id_rsa

    echo "$USER's identify added...."
}

host_is_up(){     # pass the hostname to check as $1
# check and make sure the host is up on the localnet

    ( ping -c3 $1 &>/dev/null ) && return 0
    down_hosts+=( $1 )
    echo -e "\n=====> HOST: $1 is Down <======\n"
    return 1

}

update_host(){     # Run the actual update on each host in the file

    for h in "${hosts[@]}"; do

        host_is_up "$h" || continue  # skip hosts that are down

        echo -e "\n=======> HOST: $h  <=======\n"

        if [ ! `cat /etc/hostname` == "$h" ]; then
ssh -tt $USER@$h.lan   << EOF
[[ -f "$lock_file" ]] && locked_hosts+=( "$h.lan" )
[[ "${arch_hosts[@]}" =~ "$h" ]] && echo "$passwd" | sudo -S pacman --noconfirm -Syyu 
[[ "${deb_hosts[@]}" =~ "$h" ]] && echo "$passwd" | sudo -S apt update && sudo -S apt dist-upgrade -y; exit
exit
EOF
        else
            echo "$passwd" | sudo -S pacman --noconfirm -Syyu
        fi


    done
}

print_locked(){
    if [ ${#locked_hosts[@]} -eq 0 ] ; then
        echo -e "\n=== No Locked Hosts ===\n"
    else
        echo -e "\n=== LOCKED HOSTS ===\n"
        echo "${locked_hosts[@]}"
        echo -e "\n=== DOWN HOSTS ===\n"
        echo "${down_hosts[@]}"
    fi
}

main(){
    identify
    update_host
    print_locked
}


### MAIN ###
main

