#!/bin/bash
#Check EFI and partition disk.

ls /sys/firmware/efi/efivars
if [ "$?" != "0" ]; then
	echo "[Error] not booted in EFI mode!" 1>&2
	exit 1
fi
DISK=/dev/sda
sgdisk -og $DISK
sgdisk -n 1:2048:4095 -t 1:ef02 $DISK
ENDSECTOR=`sgdisk -E $DISK`
sgdisk -n 2:4096:1130495 -t 2:ef00 -n 3:1130496:$ENDSECTOR -t 2:8309 $DISK
sgdisk -p $DISK
echo "Use cryptsetup luksFormat --type luks1 /dev/sda3 to set up your encryption, then cryptsetup open /dev/sda3 cryptlvm to mount it. Move to install1.sh."
