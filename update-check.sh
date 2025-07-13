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

# Set variables
machine=$(hostname)

## Set Working directory
pushd ~/GitHub/PurpleNix/

## Test the new system config but don't make it bootable
sudo nixos-rebuild dry-run -I nixos-config=./Config.${machine}/configuration.nix --upgrade
echo "Run \"./switch-config.sh\" to install available updates"


## Check for LVFS firmware updates
fwupdmgr refresh --force
fwupdmgr get-updates
echo "Run \"fwupdmgr update\" to install available updates"

## Return to directory you ran the script from
popd