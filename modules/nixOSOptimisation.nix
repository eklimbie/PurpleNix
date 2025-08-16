{
  # config,
  # lib,
  # pkgs,
  # pkgsUnstable,
  ...
}:
let
  flakePath = "/home/ewout/GitHub/PurpleNix#";
in
{
  imports = [
  ];

  options = {
  };

  config = {

    ##########
    ## NixOS Optimisation
    # Enable auto updating, but do not enable auto-reboot
    system.autoUpgrade = {
      enable = true;
      flake = flakePath;
      allowReboot = false;
      dates = "daily";
      operation = "switch";
      persistent = true;
      randomizedDelaySec = "2h";
    };
    # This setting will de-duplicate the nix store periodically, saving space
    nix.optimise = {
      automatic = true;
      persistent = true;
    };
    # This will automatically remove older no longer needed generations
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
      persistent = true;
    };

  };
}
