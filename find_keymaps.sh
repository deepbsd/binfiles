#!/usr/bin/env bash

keymaps=()
keymaps=$(find /usr/share/kbd/keymaps/ -type f -printf "%f\n" | sort -V)

options=()

for kmap in ${keymaps[@]} ; do
    echo ${kmap} | sed 's/.map.gz//g'
    options+=( "${kmap%.*}" )
done
