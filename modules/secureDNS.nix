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

      # Configure dns0.eu with .local domain resolution
      extraConfig = ''
        [Resolve]
        DNS=193.110.81.0#dns0.eu
        DNS=2a0f:fc80::#dns0.eu
        DNS=185.253.5.0#dns0.eu
        DNS=2a0f:fc81::#dns0.eu
        # Allow local resolution to bypass encrypted DNS
        # Domains=~. local
      '';
    };

  };
}
