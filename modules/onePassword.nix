{
  # config,
  # lib,
  pkgs,
  # pkgsUnstable,
  ...
}:
{
  imports = [
  ];

  options = {
  };

  config = {

    # Install apps via modules
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "ewout" ]; # Grant necessary system permissions to integrate with GNOME/system services.
    };

    ## 1Password Set-up
    # If it ever does not work, you can change these to "lib.mkForce false" to override NixOS priority setting.
    security.polkit.enable = true; # Polkit rules for 1Password (additional security integration)
    programs.ssh.startAgent = false; # Disable the default SSH agent, so that 1Password can provide its own

    # Keep GNOME keyring but exclude SSH component
    services.gnome.gnome-keyring.enable = true;
    # Override to disable only SSH agent component
    # systemd.user.services.gnome-keyring-ssh = {
    #   enable = false;
    # };

    # Resolve Gnome/KDE Plasma SSH askPassword conflicts
    # programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass"; # KDE/Plasma
    programs.ssh.askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass"; # Gnome

    # System-wide environment variable fallback
    environment.sessionVariables = {
      # SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
      SSH_ASKPASS_REQUIRE = "prefer"; # do explicit check if GUI is available.
    };

    # Disable GPG agent SSH support (conflicts with 1Password)
    programs.gnupg.agent.enableSSHSupport = false;

  };
}
