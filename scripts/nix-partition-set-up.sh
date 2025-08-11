#!/usr/bin/env sh
# PurplePC is a collection of scripts and documentation made by Ewout Klimbie
# Version 1.1, Copyright 2025.

# This file is part of PurpleNix.

# PurpleNix is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# PurpleNix is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with PurpleNix. If not, see <https://www.gnu.org/licenses/>.

## Automate most steps that are needed for a Btrfs install
# Per instructions of: https://wiki.nixos.org/wiki/Btrfs

## Command to check partition table before Running this script 
# sudo lsblk -o name,pttype,parttypename,partlabel,fstype,fsver,partflags,mountpoint,label,size /dev/nvme0n1
# It should generate the following output:
# NAME        PTTYPE PARTTYPENAME     PARTLABEL FSTYPE      FSVER PARTFLAGS MOUNTPOINT LABEL   SIZE
# nvme0n1     gpt                                                                            931,5G
# ├─nvme0n1p1 gpt    EFI System                 vfat        FAT32           /boot                1G
# └─nvme0n1p2 gpt    Linux filesystem           crypto_LUKS 2                                930,5G
#   └─enc                                       btrfs                       /home            930,5G

## Set Variables
disk=/dev/nvme0n1

# Creating a LUKS encrypted container 
sudo cryptsetup --verify-passphrase -v luksFormat ${disk}p2 
sudo cryptsetup open ${disk}p2 enc

read -p "LUKS encrypted container Set-up. Press any key to contiue..."

# Creating all volumes and subvolumes
sudo mkfs.btrfs /dev/mapper/enc
sudo mkdir -p /mnt
sudo mount -t btrfs /dev/mapper/enc /mnt
sudo btrfs subvolume create /mnt/nixos
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/swap
sudo umount /mnt

read -p "All BTRFS volumes Created. Press any key to contiue..."

## Mount the partitions and subvolumes
sudo mount -o compress=zstd,subvol=nixos /dev/mapper/enc /mnt
sudo mkdir /mnt/{home,nix,swap}
sudo mount -o compress=zstd,subvol=home /dev/mapper/enc /mnt/home
sudo mount -o compress=zstd,noatime,subvol=nix /dev/mapper/enc /mnt/nix
sudo mount -o noatime,subvol=swap /dev/mapper/enc /mnt/swap
sudo mkdir /mnt/boot
# The umask is needed to prevent NixOS from reporting a security problem during install. See https://discourse.nixos.org/t/security-warning-when-installing-nixos-23-11/37636
sudo mount -o umask=0077 ${disk}p1 /mnt/boot

read -p "All volumes are mounted and ready. Press any key to contiue..."

## Create Nixos config and open it
sudo nixos-generate-config --root /mnt
#sudo nano /mnt/etc/nixos/configuration.nix
#sudo nixos-install
