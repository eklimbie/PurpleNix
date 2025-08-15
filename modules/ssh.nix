{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
  ];

  options = {
  };

  config = {

    # Enable SSH with secure configuration
    services.openssh = {
      enable = false;
      settings = {
        PasswordAuthentication = false; # Only allow key-based authentication
        KbdInteractiveAuthentication = false; # Disable keyboard-interactive auth
        PermitRootLogin = "no"; # Never allow root login via SSH
      };
    };

  };
}
