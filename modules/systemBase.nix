{
  # config,
  # lib,
  # pkgs,
  # pkgsUnstable,
  ...
}:
{
  imports = [
    ./appsCoreCLI.nix
    #./bootloader.nix
    ./network.nix
    ./l18n.nix
    ./nixOSOptimisation.nix
    ./secureDNS.nix
  ];

  options = {
  };

  config = {
  };
}