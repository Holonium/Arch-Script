#!/bin/bash
#Finish setting up the install.

genfstab -U /mnt/etc/fstab
arch-chroot /mnt
