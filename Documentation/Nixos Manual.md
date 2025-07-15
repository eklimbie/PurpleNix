# NixOS Manual

## Partitioning and Install

1. Get the latest image from NixOS and install that on an USB-key.
2. Copy the most recent version of [PurpleNix](https://github.com/eklimbie/PurpleNix) from GitHub to another USB-key.
3. Boot into the NixOS live environment.
4. Open ```GParted``` and delete all existing partitions and click apply and confirm.
5. Create a new partition table by clicking on ```Device``` and then ```Create Partition Table```. Choose the ```gpt``` table type and apply.
6. Create a new partition with the following specs, any field omitted is left at the default.

    - Free space preceding (MiB): 1
    - New Size (MiB): 1024
    - Align to: MiB
    - Create as: Primary Partition
    - File system: fat32

7. Name this partition ```boot```. This will enable the nix config to use ```/dev/disk/by-partlabel/``` instead of ```/dev/disk/by-uuid/``` making is more flexible for use on multiple machines.
8. Apply pending actions. Right click on your newly created partition and click on ```Manage Flags```. Click on ```boot```, this will deselect other options and enable ```esp```. That is okay, so click ```Close```.
9. Create another new partition with the following specs, any field omitted is left at the default.

    - Free space following (MiB): 0
    - Align to: MiB
    - Create as: Primary Partition
    - Partition name: EFI
    - File system: cleared

10. Name this partition ```system```.
11. Apply your changes and close GParted.
12. The next step is to set up our encrypted partition scheme. Luckily we have a script for this. Open ```Files``` and navigate to the PurpleNix copy you made earlier. Copy the ```nix-partition-set-up.sh``` to your home folder.
13. Right click on ```nix-partition-set-up.sh``` in your home folder and enable ```Executable as Program```. Right click again, choose ```Open With…``` and open in ```Text Editor```.
14. Before we can run the script we need to verify if the partitioning is correct. At the of the Script there are instructions on how to check if you are ready to execute it. If everything is looks good you can move to the next step.
15. Check if the disk name in the script (set under variables) is correct.
16. Open ```Console``` and run the script with sudo permissions. Read and follow the instructions carefully!

    ```sh
    sudo ./nix-partition-set-up.sh
    ```

17. Open ```files``` and navigate to your USB-key with the most recent PurpleNix config files. and open any that you want to use.
18. Open the config file that script just generated, with nano

    ```sh
    sudo nano /mnt/etc/nixos/configuration.nix
    ```

19. Delete everything in the generated file and paste your own config.
20. Remember to:

    - Change the hostname in the config file to the name of your machine.
    - Check if the UUID of the LUKS partition is correct

21. Safe the file and exit.
22. Now there is only one step left: installation of your OS:

    ```sh
    sudo nixos-install
    ```

23. At the end of your install you will have to set a root password. Choose something that differs from your account password.
24. After the installer finishes, reboot
25. You are done 😀

## First Boot

The first boot will be slow, because the OS is generating a swapfile.

### Set-up a New Password for Your User

1. Before you log in, we have to change the password for your user. The configuration.nix file lists the initial password of your user.
2. At the log-in screen type ```ctrl```+```alt```+```F1``` to get a terminal log in with your username and initial password.
3. Change your password:

    ```sh
    passwd && exit
    ```

4. Switch back to the graphical login screen by typing ```ctrl```+```alt```+```F2```

### Set-up Extra Mouse Buttons

1. Open ```Input Remapper``` and click on the ```Logitech USB Receiver 2```. Click ```new preset```, type ```Expose``` and click the save icon. Toggle ```Autoload``` to on.
2. Click ```Add``` to add a button mapping, click ```Record```, and click the button on your mouse that you would like to map.
3. Under the ```Output``` section click on ```Key or Macro``` and click on the ```Enter your output here``` and type ```Super_L```.
4. Click ```Apply``` and test if it works. Close Input remapper.

### Set-up TPM Unlocking of Your Device

1. Verify that the TPM is working

    ```sh
    # Check TPM devices exist
    ls -la /dev/tpm*
    
    # Test TPM functionality
    sudo tpm2_selftest
    sudo tpm2_getrandom 8 --hex
    
    # Check LUKS device
    sudo cryptsetup luksDump /dev/disk/by-partlabel/system
    ```

2. Enroll the TPM Key with LUKS

    ```sh
    # Enroll TPM for automatic unlocking
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-partlabel/system
    
    # Enroll TPM for automatic unlocking, with PIN
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 --tpm2-with-pin=yes /dev/disk/by-partlabel/system 

    # Verify enrollment
    sudo systemd-cryptenroll --list /dev/disk/by-partlabel/system
    ```

3. You should see output showing both password and TPM2 slots enrolled.
4. Test Automatic Unlocking

    ```sh
    # Reboot to test automatic unlock
    sudo shutdown -r
    ```

#### Re-enrollment of TPM in LUKS to Auto Unlock

After a firmware updates, hardware changes, or other issues you may have to enroll the TPM key again to make it work. The commands below help you do the easy fix that works in 90% of cases. If you need more detail check out [[nixos-tpm-recovery-guide]].

1. Check what the correct device is and wipe the the tpm unlock

    ```sh
    # Find your LUKS UUID
    sudo blkid | grep crypto_LUKS
    
    # Remove existing TPM enrollment
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-partlabel/system
    ```

2. Continue with step two of [Set-up TPM Unlocking of Your Device](### Set-up TPM Unlocking of Your Device).

## NixOS Cheat Sheet

```sh
# Check if there are upgrades available
sudo nixos-rebuild dry-run --upgrade

# Clean-up old unreferenced (unused packages)
nix-collect-garbage --delete-older-than 30d

# Clean-up old generations
sudo nix-collect-garbage -d && sudo nixos-rebuild switch

# Clean-up old generations, sync and reboot 
sudo nix-collect-garbage -d && sudo nixos-rebuild switch && ./nix-config-backup.sh && sudo shutdown -r now

# Compact duplicate packages bz replacing them with links (saves tons of space, but very time intensive)
nix-store --optimise

# Clean-up boot partition by removing old (unused profiles)
nixos-rebuild switch

# List all Generations of NixOS that Are available
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# List paritions
sudo lsblk -o name,pttype,parttypename,partlabel,fstype,fsver,partflags,mountpoint,label,size /dev/nvme0n1
```
