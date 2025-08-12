{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  ##########
  ## Network Set-up
  networking.hostName = "NixNuc"; # Define your host name.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  ## Enable Encrypted DNS
  # Enable systemd-resolved for DNS management
  services.resolved = {
    enable = true;
    dnsovertls = "true";
    dnssec = "false";

    # Configure local domain resolution
    extraConfig = ''
      [Resolve]
      DNS=193.110.81.0#dns0.eu
      DNS=2a0f:fc80::#dns0.eu
      DNS=185.253.5.0#dns0.eu
      DNS=2a0f:fc81::#dns0.eu
      # Allow local resolution to bypass encrypted DNS
      Domains=~. local
    '';
  };

  # Ensure NetworkManager doesn't override DNS settings
  networking.networkmanager.dns = "systemd-resolved";

  # Enable mDNS for .local domain resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Enable mDNS resolution via NSS
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };

}
