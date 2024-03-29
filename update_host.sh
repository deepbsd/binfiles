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



# Get the sudo user password
echo -n 'What is your sudo user password?   '
read passwd


######  Functions  ###################

identify(){    # Get the users credentials

    if pgrep ssh-agent ; then
        echo ssh-agent already running...
    else
        eval $(ssh-agent)
    fi
    ssh-add
    echo "$USER's identify added...."
}


update_host(){     # Run the actual update on each host in the file

    for h in "${hosts[@]}"; do

        echo "=======> HOST: $h  <======="

        if [ ! `cat /etc/hostname` == "$h" ]; then
ssh -tt $USER@$h.lan  << EOF
[[ -f "$lock_file" ]] && locked_hosts+=( "$h.lan" )
[[ "${arch_hosts[@]}" =~ "$h" ]] && echo "$passwd" | sudo -S pacman --noconfirm -Syyu
[[ "${deb_hosts[@]}" =~ "$h" ]] && echo "$passwd" | sudo -S apt update && sudo -S apt dist-upgrade -y
exit
EOF
        else
            echo "$passwd" | sudo -S pacman --noconfirm -Syyu
        fi

    [[ $? -ne 0 ]] && locked_hosts+=( "$h.lan" )

    done
}

print_locked(){
    if [ ${#locked_hosts[@]} -eq 0 ] ; then
        echo "=== No Locked Hosts ==="
    else
        echo "=== LOCKED HOSTS ==="
        echo "${locked_hosts[@]}"
    fi
}

main(){
    identify
    update_host
    print_locked
}


### MAIN ###
main

