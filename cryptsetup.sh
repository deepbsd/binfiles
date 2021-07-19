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



## PARTITION DRIVE
parted -s "$DRIVE" mklabel gpt

parted -s "$DRIVE" unit mib mkpart primary 1 512 

parted -s "$DRIVE" mkpart primary 2 100%

parted -s "$DRIVE" set 2 lvm on


# CHECK PARTITIONS
lsblk "$DRIVE"
read -p "Here're your partitions... Hit enter to continue..." empty

# FORMAT EFI PARTITION
mkfs.vfat -f32 "${DRIVE}1"

# CREATE PHYSICAL VOL
pvcreate /dev/mapper/"$CRYPTVOL"


# SETUP ENCRYPTED VOLUME
cryptsetup -y -v luksFormat $1 --key-file /tmp/passphrase
cryptsetup luksOpen  "${DRIVE}2" $CRYPTVOL

# CREATE VOLUME GRP and LOGICAL VOLS
vgcreate "$VOLGRP" "$CRYPTVOL"

lvcreate -L "$ROOT_SIZE" "$CRYPTVOL" -n "$LV_ROOT"

lvcreate -L "$SWAP_SIZE" "$CRYPTVOL" -n "$LV_SWAP"

lvcreate -l 100%FREE "$CRYPTVOL" -n "$LV_SWAP"


# FORMAT VOLUMES

mkfs.ext4 "/dev/${CRYPTVOL}/${LV_ROOT}"
mkfs.ext4 "/dev/${CRYPTVOL}/${LV_HOME}"
mkswap "/dev/${CRYPTVOL}/${LV_SWAP}"



