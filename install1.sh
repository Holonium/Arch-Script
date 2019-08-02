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
echo "This script will now go into a chroot, after having copied the pertinent items to the chroot device."
cp locale.conf /mnt/etc/locale.conf
rm /mnt/etc/hosts
cp hosts /mnt/etc
echo "Please enter a hostname: "
read host
sed -i "s/hostname/$host/g" /mnt/etc/hosts
cat << EOF | arch-chroot /mnt /bin/bash
	sed -i 's/Storage=volatile/#Storage=auto/' /etc/systemd/journald.conf
	rm /etc/udev/rules.d/81-dhcpcd.rules
	systemctl disable pacman-init.service choose-mirror.service
	rm -r /etc/systemd/system/{choose-mirror.service,pacman-init.service,etc-pacman.d-gnupg.mount,getty@tty1.service.d}
	rm /etc/systemd/scripts/choose-mirror
	rm /root/{.automated_script.sh,.zlogin}
	rm /etc/mkinitcpio-archiso.conf
	rm -r /etc/initcpio

	pacman-key --init
	pacman-key --populate archlinux
EOF

genfstab -U /mnt/etc/fstab
cat << EOF | arch-chroot /mnt
	ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
	hwclock --systohc

	sed -i 's/#en_US\.UTF-8 UTF-8/en_US\.UTF8 UTF-8/g' /etc/locale.gen
	sed -i 's/HOOKS=(.)/HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems fsck)/g' /etc/mkinitcpio.conf

	locale-gen

	echo "$hostname" > /etc/hostname

	mkinitcpio -p linux

	UUID=blkid -s UUID -o value /dev/sda3

	sed -i "s/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/g" /etc/default/grub
	sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$UUID:cryptlvm\"/g" /etc/default/grub

	grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch --recheck
	grub-mkconfig -o /boot/grub/grub.cfg
	echo "Next, use passwd to set the root password, then umount -R /mnt and reboot. Enjoy your installation."
EOF
arch-chroot /mnt
