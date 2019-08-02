#!/bin/bash
#Continue in chroot environment

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc

sed -i 's/#en_US\.UTF-8 UTF-8/en_US\.UTF8 UTF-8/g' /etc/locale.gen
sed -i 's/HOOKS=(.)/HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems fsck)/g' /etc/mkinitcpio.conf

locale-gen

echo "DarkstarXII" > /etc/hostname

mkinitcpio -p linux

UUID=blkid -s UUID -o value /dev/sda3

sed -i "s/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/g" /etc/default/grub
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$UUID:cryptlvm\"/g" /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch --recheck
grub-mkconfig -o /boot/grub/grub.cfg

exit

echo "Next, use passwd to set the root password, then umount -R /mnt and reboot. Enjoy your installation."
