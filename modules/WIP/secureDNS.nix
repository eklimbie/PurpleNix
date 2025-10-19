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

    #########
    ## Enable Encrypted DNS

    # Ensure NetworkManager doesn't override DNS settings
    networking.networkmanager.dns = "systemd-resolved";

    # Enable systemd-resolved for DNS management
    services.resolved = {
      enable = true;
      dnsovertls = "true";
      dnssec = "false";
      # Allow local resolution to bypass encrypted DNS
      domains = [
        "~."
        "local"
      ];

      # Configure quad9 with .local domain resolution
      extraConfig = ''
        [Resolve]
        DNS=9.9.9.9#quad9.net
        DNS=2620:fe::fe#quad9.net
        DNS=149.112.112.112#quad9.net
        DNS=2620:fe::9#quad9.net
      '';
    };

  };
}
