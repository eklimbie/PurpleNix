{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{

  ##########
  ## Configure Keymap
  # Configure key-map in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl"; # Can also be an empty string ""
    # options = "";
  };
  # Configure Console keymap
  # console.keyMap = "us"; # Default
  console.useXkbConfig = true; # Make the rest of the system follow X11

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
  
    # piper
    # pkgsUnstable.piper
    # libratbag
    # pkgsUnstable.libratbag
    
  ];

  ##########
  ## List services that you want to enable:

  #services.ratbagd = {
  #  enable = true;
  #  package = pkgsUnstable.libratbag;
  #};

  # Enable Input-remapper to easily change the mapping of your input device buttons
  services.input-remapper.enable = true;

}
