{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
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
    apostrophe
    calibre
    celluloid
    digikam
    dconf-editor
    eyedropper
    foliate
    gimp3-with-plugins
    github-desktop
    gitg
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
    high-tide
    impression
    pkgsUnstable.joplin-desktop # fixes wayland issue on the 25.05 stable channel
    joplin-desktop
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
    todoist-electron
    tor-browser
    transmission_4-gtk
    vlc
    vscode
    warp
  ];

  ##########
  ## List services that you want to enable:

  # Enable Jotta
  services.jotta-cli = {
    enable = true;
    # options = [ ];
  };
}
