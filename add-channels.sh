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

sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware

sudo nix-channel --update
sudo nix-channel --list