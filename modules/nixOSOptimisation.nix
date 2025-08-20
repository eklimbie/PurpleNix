{
  # config,
  # lib,
  pkgs,
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
        # "--recreate-lock-file"
        # Commit the updated lock file (requires the path to be a git repo):
        "--commit-lock-file"
        # Quality-of-life:
        "--print-build-logs"
      ];
    };

    # Ensure the upgrade service waits for network-online
    systemd.services.nixos-upgrade = {
      # If you’re on NetworkManager, actively wait up to 30s for connectivity:
      # nm-online exits 0 when the network is considered "online".
      preStart = "${pkgs.networkmanager}/bin/nm-online -q -t 30";
    };

    # Mark the flake file as safe for root as it's in a repo not owned by root
    programs.git = {
      enable = true;
      config = {
        safe.directory = [ flakePath ];
      };
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
