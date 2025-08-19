{
  # config,
  # lib,
  # pkgs,
  # pkgsUnstable,
  ...
}:
let
  flakePath = "/home/ewout/GitHub/PurpleNix";
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
    # /etc/nixos/configuration.nix  (or your flake module)
    system.autoUpgrade = {
      enable = true;
      # Point to your flake; nixos-rebuild will pick the host attr by hostname.
      flake = flakePath;
      allowReboot = false;
      operation = "switch";
      dates = "daily";
      persistent = true;
      randomizedDelaySec = "2h";
      flags = [
        # Update the lock file like `nix flake update` would:
        "--recreate-lock-file"
        # Commit the updated lock file (requires the path to be a git repo):
        # "--commit-lock-file"
        # Quality-of-life:
        "--print-build-logs"
      ];
    };

    # This setting will de-duplicate the nix store periodically, saving space
    nix.optimise = {
      automatic = true;
      persistent = true;
    };
    # This will automatically remove older no longer needed generations
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
      persistent = true;
    };

  };
}
