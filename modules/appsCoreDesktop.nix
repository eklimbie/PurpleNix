{
  # config,
  # lib,
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

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Install apps via modules
    programs.chromium.enable = true;
    programs.firefox.enable = true;
    programs.steam.enable = true;

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [

      # CLI Applications and other tools
      borgbackup
      cdparanoia # Accurate CD Ripping
      cdrdao # CD ripping TOC/Details
      exiftool
      flac
      ffmpeg-full
      graphviz # Adds Support for graphing dependencies in FreeCAD
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_GB-large
      hunspellDicts.en_US-large
      hunspellDicts.nl_NL
      hyphenDicts.de_DE
      hyphenDicts.en_US
      nixd # Nix language server (LSP) for use in vscode
      nixfmt-rfc-style # Official formatter for Nix code
      p7zip
      rsgain
      speedtest-cli
      texliveFull
      whipper # CD ripping tool
      yt-dlp

      # GUI Applications
      calibre
      dconf-editor
      ente-desktop
      eyedropper
      freecad-wayland
      gimp3-with-plugins
      github-desktop
      gnomeExtensions.caffeine
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.smile-complementary-extension
      gnomeExtensions.tiling-shell
      gnomeExtensions.vitals
      gnome-maps
      gnome-tweaks
      google-chrome
      gparted
      handbrake
      pkgsUnstable.high-tide
      impression
      inkscape-with-extensions
      jitsi-meet-electron
      libreoffice-fresh
      makemkv
      obsidian
      orca-slicer
      papers
      picard
      pika-backup
      plex-desktop
      protonvpn-gui
      quodlibet-full
      resources
      roomeqwizard
      signal-desktop
      smile # Emoji pciker for Gnome
      showtime
      switcheroo
      todoist-electron
      tor-browser
      typora
      transmission_4-gtk
      vlc
      vscode
      warp
      zapzap
      zoom-us
    ];

    ##########
    ## Enable declarative install of Flatpaks
    # Enable integration of flatpaks with the system
    xdg.portal.enable = true;

    # Install & Configure Flatpak
    services.flatpak = {
      enable = true;
      # Remove any flatpak not installed declaratively
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };

      # Flatpaks to install
      packages = [
        {
          appId = "com.bambulab.BambuStudio";
          origin = "flathub";
        }
        {
          appId = "com.fastmail.Fastmail";
          origin = "flathub";
        }
        # add more app IDs here
      ];
    };

    ##########
    ## List services that you want to enable:
    
    # Enable Jotta
    services.jotta-cli = {
      enable = true;
      # options = [ ];
    };

    # Enable MakeMKV to see DVD/Blu-ray drives
    boot.kernelModules = [ "sg" ]; # Load the scsi driver that MakeMKV relies on
    # services.udev.packages = [ pkgs.makemkv ]; # Load the MakeMKV udev rules, not needed

    ##########
    ## Firewall set-up
    # Open ports for applications that need it
    networking.firewall = {
      allowedTCPPorts = [
        51047 # Transmission
      ];
      allowedUDPPorts = [
        51047 # Transmission
      ];
    };
  };
}
