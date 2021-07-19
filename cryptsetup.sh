#!/usr/bin/env bash

# Let's set up the steps for automating a crypt setup for lvm on uefi, partitioning with luks!
# we're using parted for creating partitions

DRIVE=/dev/sda
CRYPTVOL="arch_crypt"
VOLGRP="arch_vg"

LV_ROOT="ArchRoot"
LV_SWAP="ArchSwap"
LV_HOME="ArchHome"

ROOTSIZE=13G
SWAPSIZE=4G
HOMESIZE=""



parted -s "$DRIVE" mklabel gpt

parted -s "$DRIVE" unit mib mkpart primary 1 512 

parted -s "$DRIVE" mkpart primary 2 100%

parted -s "$DRIVE" set 2 lvm on

# next part is format efi partition and then use cryptsetup on second physical volume

lsblk "$DRIVE"

mkfs.vfat -f32 "${DRIVE}1"

pvcreate /dev/mapper/"$CRYPTVOL"

vgcreate "$VOLGRP" "$CRYPTVOL"

lvcreate -L "$ROOT_SIZE" "$CRYPTVOL" -n "$LV_ROOT"

lvcreate -L "$SWAP_SIZE" "$CRYPTVOL" -n "$LV_SWAP"

lvcreate -l 100%FREE "$CRYPTVOL" -n "$LV_SWAP"

