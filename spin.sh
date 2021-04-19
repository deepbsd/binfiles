#!/usr/bin/env bash

spinner=( Ooooo oOooo ooOoo oooOo ooooO )

spinner1=( ' |' ' /' '--' ' \' )

message="...copying files"

start=1
end=15

copy(){
    spin &
    pid=$!

    for i in $(seq $start $end); do
        sleep 1
    done

    kill $pid
    echo ""
}

spin(){
    while [ 1 ] ; do
        for i in "${spinner[@]}"; do
            echo -ne "\r$i  $message"
            sleep 0.2
        done
    done
}

copy && clear && echo "All done!"
