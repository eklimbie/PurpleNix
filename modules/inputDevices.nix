{
  # config,
  # lib,
  pkgs,
  # pkgsUnstable,
  ...
}:
let
  user = "ewout";
in
{
  imports = [
  ];

  options = {
  };

  config = {

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

    # Enable support for Razer devices
    hardware.openrazer = {
      enable = true;
      users = [ user ];
    };

    # Enable support for Logitechl devices
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [

      polychromatic # Configure Razer devices
      keyd # Flexible keyboard & mouse button remapper
      solaar # Configure logitech devices

    ];

    ##########
    ## List services that you want to enable:

    # Set-up remapping of mouse buttons
    services.keyd = {
      enable = true;
      # Caps-lock fix for all Keyboards:
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              # Remap capslock to another control key when held, and an escape key when tapped
              capslock = "overload(control, esc)";
            };
          };
        };
        # Button mapping for Razer DeathAdder v3 Pro
        mouseDAv3Pro = {
          ids = [ "1532:00b7" ];
          settings = {
            main = {
              mouse1 = "leftmeta";
            };
          };
        };
        # Button mapping for Logitech G705
        mouseG705 = {
          ids = [
            "046d:c547" # USB Dongle
            "046d:b02e" # Bluetooth
          ];
          settings = {
            main = {
              mouse1 = "leftmeta";
            };
          };
        };
      };
    };
  };
}
