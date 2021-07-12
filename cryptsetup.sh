#!/usr/bin/env bash

# Let's set up the steps for automating a crypt setup for lvm on uefi, partitioning with luks!
# we're using parted for creating partitions

DRIVE=/dev/sda

parted -s "$DRIVE" mklabel gpt

parted -s "$DRIVE" unit mib mkpart primary 1 512 

parted -s "$DRIVE" unit mib mkpart primary 2 100%

parted -s "$DRIVE" set 2 lvm on


