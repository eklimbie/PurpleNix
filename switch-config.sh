#!/usr/bin/env sh
# PurplePC is a collection of scripts and documentation made by Ewout Klimbie
# Version 1.0, Copyright 2025.

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

## Set variables
machine=$(hostname)
configpath=$HOME/GitHub/PurpleNix/Config.$(hostname)/
generation="$(basename "$(readlink /nix/var/nix/profiles/system)" | cut -d- -f2)"

## Check if Config folder exists
# To be added

## Set Working directory
pushd ~/GitHub/PurpleNix

## Switch the system to the new config and make it bootable
sudo nixos-rebuild switch -I nixos-config=${configpath}/configuration.nix
popd

## Copy the new config to the system config folder
echo "Copying the configuration to the system config folder..."
sudo cp ${configpath}/* /etc/nixos/

## Add updated config to GitHub repository
echo "Committing the updated configuration to the repository..."
git add ${configpath}/*
git commit -m "Updated ${machine} NixOS configuration to generation ${generation}"
git push

## Return to directory you ran the script from
popd