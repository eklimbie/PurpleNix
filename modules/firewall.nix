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
    ## Firewall set-up
    # Enable the firewall
    networking.firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        #139   # SMB/CIFS
        #445   # SMB/CIFS
      ];
      allowedUDPPorts = [
        #137   # SMB/CIFS
        #138   # SMB/CIFS
      ];
      # Allow specific interfaces (useful for VMs, containers, or VPNs)
      trustedInterfaces = [
        "lo" # Always trust loopback interface
        "virbr0" # Uncomment if using libvirt/KVM
        # "docker0" # Uncomment if using Docker
      ];
      # Custom firewall rules using iptables syntax
      # These run before the automatic rules
      # extraCommands = ''
      #   # Allow established and related connections (essential for normal operation)
      #   # Already enabled by NixOS by default.
      #   # iptables -A nixos-fw -m conntrack --ctstate ESTABLISHED,RELATED -j nixos-fw-accept
      #
      #   # Allow local network discovery protocols
      #   # mDNS (Bonjour/Avahi) - for .local domain resolution
      #   iptables -A nixos-fw -p udp --dport 5353 -j nixos-fw-accept
      #
      #   # DHCP client (if using DHCP to receive an IP address)
      #   iptables -A nixos-fw -p udp --sport 68 --dport 67 -j nixos-fw-accept
      #
      #   # Optional: Allow SSDP for UPnP device discovery (printers, media servers)
      #   # iptables -A nixos-fw -p udp --dport 1900 -j nixos-fw-accept
      #
      #   # Optional: Allow SMB/CIFS discovery if you access Windows shares
      #   # iptables -A nixos-fw -p udp --dport 137:138 -j nixos-fw-accept
      #   # iptables -A nixos-fw -p tcp --dport 139 -j nixos-fw-accept
      #   # iptables -A nixos-fw -p tcp --dport 445 -j nixos-fw-accept
      # '';
    };

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

  };
}
