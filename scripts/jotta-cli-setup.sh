#!/usr/bin/env sh
# PurplePC is a collection of scripts and documentation made by Ewout Klimbie
# Version 0.9, Copyright 2025.

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

# Set-up folders
mkdir ~/.appdata
mkdir ~/.appdata/jottacloud

# Set-up Back-up
jotta-cli login 
jotta-cli add ~
jotta-cli ignores add --pattern ~/home/ewout/.cache
jotta-cli ignores add --pattern ~/.local/share/Trash
jotta-cli ignores add --pattern ~/GitHub
jotta-cli ignores add --pattern ~/.appdata/jottacloud

# Set-up Sync
jotta-cli sync setup --root ~/.appdata/jottacloud/
jotta-cli sync start


# Set-up Documents and Pictures folders as a symbolic link
rm -r ~/Documents
ln -s ~/.appdata/jottacloud/Documents ~/Documents
rm -r ~/Pictures
ln -s ~/.appdata/jottacloud/Pictures ~/Pictures