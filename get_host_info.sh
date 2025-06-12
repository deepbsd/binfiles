#!/usr/bin/env bash

# This script simply ssh'es into a host and gets its cpu and mobo information, then
# prints it out at the end

hosts_file=$HOME/bin/hosts.txt
hosts=( $(cat $hosts_file) )
down_hosts=()
mobo=""
mycpu=""


host_is_up(){     # pass the hostname to check as $1
# check and make sure the host is up on the localnet

    ( ping -c3 $1 &>/dev/null ) && return 0
    down_hosts+=( $1 )
    echo -e "\n=====> HOST: $1 is Down <======\n"
    return 1
}


get_info(){
    # set up the variables for each host
    passwd='rtfm4me'
    mycpu=`lscpu | grep 'Model name' | cut -c 39-`
    mobo=`echo "$passwd" | sudo -S dmidecode -t baseboard | grep -e 'Product Name' | sed -e 's/^.*: *//'` 
    echo -e "\n*****>$mobo $mycpu<******\n"
    exit
}


print_down(){
    # Print hosts that are offline
    if [ ${#down_hosts[@]} -eq 0 ]; then
        echo -e "\n=== No Hosts Down ===\n"
    else
        echo -e "\n===> DOWN HOSTS <===\n"
        echo "${down_hosts[@]}"
    fi
}

main(){
    # if we're on a remote host, run the first command; else 
    # run the second command
    for h in "${hosts[@]}" ; do

        host_is_up "$h" || continue  # skip hosts that are down

        echo -e "\n=======> HOST: $h  <=======\n"

        if [ ! `cat /etc/hostname` == "$h" ]; then

            ssh $USER@$h.lan "$(typeset -f get_info); get_info" 
       
        else
           echo "Localhost: "
           mycpu=$( lscpu | grep 'Model name' | sed -e 's/^.*: *//' )
           mobo=$( echo "$passwd" |  sudo -S dmidecode -t baseboard | grep -e 'Product Name'  | sed -e 's/^.*: //' )
           echo "CPU: $mycpu MOBO: $mobo"
           mycpu=""; mobo="";
        fi
    done
}


main
print_down
