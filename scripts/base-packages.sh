#!/bin/bash

pacman -Syu
pacman -S --needed audacity blender binutils chrome-gnome-shell efitools fakeroot firefox gcc git gnome gimp gnome-tweaks gnucash gpa gpart gparted handbrake hunspell-en_US make nmap openssh p7zip sudo wireshark vlc zenmap

#Install dependencies for AUR
pacman -S --needed git pacutils perl-data-dump perl-json perl-libwww perl-lwp-protocol-https perl-term-readline-gnu perl-term-ui perl highlight perl-json-xs
pacman -S --needed alsa-lib gconf glibc gtk3 libnotify libxss nspr nss xdg-utils libpulse
pacman -S --needed desktop-file-utils gconf glib2 gtk2 libcurl-gnutls libsystemd libx11 libxss libxtst nss openssl-1.0 rtmpdump alsa-lib
