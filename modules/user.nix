{
  # config,
  # lib,
  # pkgs,
  # pkgsUnstable,
  ...
}:
{
  imports = [
  ];

  options = {
  };

  config = {

    ##########
    ## User Set-up
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.ewout = {
      isNormalUser = true;
      initialPassword = "ewout";
      description = "Ewout Klimbie";
      extraGroups = [
        # "libvirtd" # Enable use of virtual machines
        "networkmanager" # Default
        # "tss" # Gives access to TPM devices without sudo
        "wheel" # Allows sudo
        "cdrom" # Allows all apps access to the USB-drive
      ];
    };

  };
}
