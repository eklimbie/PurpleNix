{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ./systemBase.nix
    ./appsCoreDesktop.nix
    ./fonts.nix
    ./gnome.nix
    ./inputDevices.nix
    ./onePassword.nix
    ./sound.nix
    ./user.nix


  ];

  options = {
  };

  config = {
  };
}