{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  ## Yubikey login and sudo support
  # Make sure to create an authorisation mapping for your yubikey and add to
  # the home-manager config.
  services.pcscd.enable = true; # Enable smartcard (CCID) of Yubikey

  # Enable U2F PAM support
  security.pam.u2f = {
    enable = true;

    # Choose authentication mode:
    # "sufficient" = Yubikey OR password works
    # "required" = Yubikey AND password needed
    control = "sufficient";

    # Show "Please touch the device" message
    settings.cue = true;
  };

  # Enable U2F for specific services
  security.pam.services = {
    login.u2fAuth = false; # Physical TTY login
    sudo.u2fAuth = true; # Sudo commands
    polkit-1.u2fAuth = true; # GUI admin prompts
    gdm.u2fAuth = false; # For Gnome GDM login
    # gdm-password.u2fAuth = false; # Gnome GDM password service
    # gdm-fingerprint.u2fAuth = false; # Gnome GDM fingerprint
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubioath-flutter
  ];

}
