{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  ##########
  ## List services that you want to enable:

  # Enable Input-remapper to easily change the mapping of your input device buttons
  services.input-remapper.enable = true;
}
