{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
  ];

  options = {
  };

  config = {

    ##########
    ## Installation of packages/software
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Install apps via modules
    programs.dconf.enable = true;
    programs.git.enable = true;
    programs.htop.enable = true;
    programs.nano.enable = true;

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [

      # CLI Applications and other tools
      btrfs-progs
      dconf2nix
      geekbench # Unfree is not correctly passed from the flake file
      nano
      p7zip
      pciutils # To get informaion about pci devices
      powertop
      speedtest-cli
      tpm2-tools # For enrolling and managing TPM keys
      tpm2-tss # TPM Software Stack
      usbutils # To get information about usb devices
      wget
    ];

    ##########
    ## List services that you want to enable:

    # Enable the Linux fwupd service
    services.fwupd.enable = true;
  
  };
}
