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

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [

      # CLI Applications and other tools
      borgbackup
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
      yt-dlp

      # GUI Applications
      calibre
      digikam
      dconf-editor
      ente-desktop
      eyedropper
      foliate
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
      jitsi-meet-electron
      pkgsUnstable.joplin-desktop # fixes wayland issue on the 25.05 stable channel
      libreoffice-fresh
      makemkv
      obsidian
      parabolic
      picard
      pika-backup
      plex-desktop
      protonvpn-gui
      resources
      signal-desktop
      smile # Emoji pciker for Gnome
      sound-juicer
      soundconverter
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
    ## List services that you want to enable:

    # Enable Jotta
    services.jotta-cli = {
      enable = true;
      # options = [ ];
    };

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
