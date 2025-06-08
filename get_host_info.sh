#!/usr/bin/env bash

# This script simply ssh'es into a host and gets its cpu and mobo information, then
# prints it out at the end

hosts_file=$HOME/bin/hosts.txt
passwd='rtfm4me'
hosts=( $(cat $hosts_file) )




host_is_up(){     # pass the hostname to check as $1
# check and make sure the host is up on the localnet

    ( ping -c3 $1 &>/dev/null ) && return 0
    down_hosts+=( $1 )
    echo -e "\n=====> HOST: $1 is Down <======\n"
    return 1

}


get_info(){

    export mycpu=$( lscpu | grep 'Model name' | cut -c 39-  )
    export mobo=$( echo "$passwd" |  sudo -S dmidecode -t baseboard | grep -e 'Manufacturer\|Product Name' | cut -c 29-  )

}


#lscpu | grep 'Model name' | cut -c 39-  
#echo "$passwd" |  sudo -S dmidecode -t baseboard | grep -e 'Manufacturer\|Product Name'  | cut -c 15-


print_info(){

    echo "$mobo $mycpu"

}


main(){

    #echo "${hosts[@]}"
    #echo ${hosts}

    for h in "${hosts[@]}" ; do

        host_is_up "$h" || continue  # skip hosts that are down

        echo -e "\n=======> HOST: $h  <=======\n"

        if [ ! `cat /etc/hostname` == "$h" ]; then

ssh -tt $USER@$h.lan   << EOF 
lscpu | grep 'Model name' | cut -c 39- 
echo "$passwd" |  sudo -S dmidecode -t baseboard | grep -e 'Manufacturer\|Product Name' | cut -c 15-
echo "$mobo $mycpu"
exit
EOF
    else
       echo "Localhost: "
       mycpu=$( lscpu | grep 'Model name' | cut -c 39-  )
       mobo=$( echo "$passwd" |  sudo -S dmidecode -t baseboard | grep -e 'Manufacturer\|Product Name'  )
       echo "$mycpu  $mobo"
    fi
    done

}


main
