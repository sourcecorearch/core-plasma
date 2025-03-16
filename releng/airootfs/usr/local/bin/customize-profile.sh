#!/bin/bash

# Executa o comando locale-gen para gerar as configurações de localização
locale-gen

# Executa o comando systemctl para habilitar o NetworkManager
systemctl enable NetworkManager

# Popula repositórios
pacman-key --init

# Habilita o gdm para o Plasma
systemctl enable sddm.service

## Script to perform several important tasks before `mkarchcoreiso` create filesystem image.

set -e -u

## -------------------------------------------------------------- ##

## Modify /etc/mkinitcpio.conf file
sed -i '/etc/mkinitcpio.conf' \
        -e "s/#COMPRESSION=\"zstd\"/COMPRESSION=\"zstd\"/g"


## Fix Initrd Generation in Installed System
cat > "/etc/mkinitcpio.d/linux.preset" <<- _EOF_
	# mkinitcpio preset file for the 'linux' package

	ALL_kver="/boot/vmlinuz-linux"
	ALL_config="/etc/mkinitcpio.conf"

	PRESETS=('default' 'fallback')

	#default_config="/etc/mkinitcpio.conf"
	default_image="/boot/initramfs-linux.img"
	#default_options=""

	#fallback_config="/etc/mkinitcpio.conf"
	fallback_image="/boot/initramfs-linux-fallback.img"
	fallback_options="-S autodetect"    
_EOF_

## Delete ISO specific init files
rm -rf /etc/mkinitcpio.conf.d
