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
    ./firewall.nix
    ./l18n.nix
    ./nixOSOptimisation.nix
    ./secureDNS.nix
  ];

  options = {
  };

  config = {
  };
}