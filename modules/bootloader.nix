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

    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        memtest86.enable = true;
        # configurationLimit = 10; # Keep only 10 boot entries to prevent boot partition from filling up.
      };
      efi.canTouchEfiVariables = true;
    };

  };
}
