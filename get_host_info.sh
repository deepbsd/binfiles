#!/usr/bin/env bash

# This script simply ssh'es into a host and gets its cpu and mobo information, then
# prints it out at the end

hosts_file=$HOME/bin/hosts.txt
passwd='rtfm4me'
hosts=$( cat "$hosts_file" )



get_info(){

    mycpu=$( lscpu | grep 'Model name' | cut -c 39-  )
    mobo=$( echo "$passwd" |  sudo -S dmidecode -t baseboard | grep -e 'Manufacturer\|Product Name' | cut -c 29-  )

}

print_info(){

    echo "$( hostname ) $mobo $mycpu"

}


main(){

    for h in "${hosts[@]}" ; do
        ssh -tt dsj@$h.lan   <<EOF 
        get_info
        print_info
        exit
EOF
    done

}


main
