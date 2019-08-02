#!/bin/bash

#Install Trizen
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si

#Install Discord
trizen -S discord

#Install Spotify
trizen -S spotify
