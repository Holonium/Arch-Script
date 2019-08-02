#!/bin/bash
#Setup inside the chroot.

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

exit
