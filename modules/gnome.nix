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

    ##########
    ## Setting up the Desktop Environment
    # Enable the KDE Plasma Desktop Environment.
    # services.xserver.enable = true;
    # services.displayManager.sddm.enable = true;
    # services.desktopManager.plasma6.enable = true; # this will enable me to also use KDE alongside Gnome

    # Enable Gnome on Wayland with fractional scaling.
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
      };
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = [ pkgs.mutter ];
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features = ['scale-monitor-framebuffer', 'xwayland-native-scaling', 'variable-refresh-rate']
        '';
      };
    };

    # Improve (font)redering for Electron apps by forcing wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    ##########
    ## List services that you want to enable:

    # Enable Gnome services
    services.gnome = {
      gnome-browser-connector.enable = true;
    };

    # Enable location service
    services.geoclue2.enable = true;

  };
}
