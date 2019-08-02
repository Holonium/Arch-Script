#!/bin/bash
#Setup disk and copy and configure various parts of the Arch install.

pvcreate /dev/mapper/cryptlvm
vgcreate system /dev/mapper/cryptlvm
lvcreate -L 8G system -n swap
lvcreate -L 32G system -n root
lvcreate -l 100%FREE system -n home

mkfs.ext4 /dev/system/root
mkfs.ext4 /dev/system/home
mkfs.fat -F32 /dev/sda2
mkswap /dev/system/swap

mount /dev/system/root /mnt
mkdir /mnt/home
mount /dev/system/home /mnt/home
mkdir /mnt/efi
mount /dev/sda2 /mnt/efi
swapon /dev/system/swap

cp -ax / /mnt
cp -vaT /run/archiso/bootmnt/arch/boot/$(uname -m)/vmlinuz /mnt/boot/vmlinuz-linux
echo "This script will now go into a chroot, after having copied the install2.sh and other pertinent items to the chroot device."
cp install{2,4}.sh /mnt
cp locale.conf /mnt/etc/locale.conf
rm /mnt/etc/hosts
cp hosts /mnt/etc
arch-chroot /mnt /bin/bash
