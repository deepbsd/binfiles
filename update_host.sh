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
read -s passwd


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

print_down-hosts(){
    echo -e "\n***> There are ${#hosts[@]} hosts up and ${#down_hosts[@]} down <***"
    if [[ ${#down_hosts[@]} -eq 0 ]]; then
        echo -e "\n=====> No Hosts Are Down <=====\n"
    else
        echo -e "\n***> Hosts That Are Down <***\n"
        for h in "${down_hosts[@]}" ; do
            echo "$h is down"
        done
    fi
}

get_info(){
    # set up the variables for each host
    passwd='rtfm4me'
    mycpu=`lscpu | grep 'Model name' | cut -c 39-`
    mobo=`echo "$passwd" | sudo -S dmidecode -t baseboard | grep -e 'Product Name' | sed -e 's/^.*: *//'` 
    echo -e "\n*****>$mobo $mycpu<******\n"
}

check_lock(){
    [[ -f "$lock_file" ]] && locked_hosts+=( "$1.lan" )
}

check_connectivity(){
    [[ $(ping -c3 archlinux.org &>/dev/null) ]] && return 0
    return 1
}

restart_nameservice(){
    passwd='rtfm4me'
    echo "****> OOPS!  Restarting Nameservice! <****"
    echo "$passwd" | sudo -S systemctl restart systemd-resolvd
}

arch_update(){
    passwd='rtfm4me'
    echo "$passwd" | sudo -S pacman --noconfirm -Syyu
}

deb_update(){
    passwd='rtfm4me'
    echo "$passwd" | sudo -S apt update && sleep 3 && echo "$passwd" | sudo -S  apt dist-upgrade -y && exit
}

update_host(){     # Run the actual update on each host in the file

    for h in "${hosts[@]}"; do

        host_is_up "$h" || continue  # skip hosts that are down

        echo -e "\n=======> HOST: $h  <=======\n"

        [[ -f "$lock_file" ]] && locked_hosts+=( "$h.lan" )

        if [ ! `cat /etc/hostname` == "$h" ]; then
ssh $USER@$h.lan bash -s <<EOF
$(typeset -f get_info)
get_info
$(typeset -f check_connectivity)
$(typeset -f restart_nameservice) 
[[ `cat /etc/hostname` == 'milo' ]] && (check_connectivity || restart_nameservice)
$(typeset -f arch_update)
[[ "${arch_hosts[@]}" =~ "$h" ]] && arch_update
$(typeset -f deb_update)
[[ "${deb_hosts[@]}" =~ "$h" ]] &&  deb_update
exit
EOF
        else
            get_info
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

    return 0
}

main(){
    identify
    update_host
    print_locked
    print_down-hosts
}


### MAIN ###
main

