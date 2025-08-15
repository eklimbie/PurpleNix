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

    # Font configuration for better text rendering
    fonts = {
      # fontconfig = {
      #   enable = true;
      #   # Hinting and subpixel fontconfig make text sharper in Gnome.
      #   subpixel = {
      #     rgba = "rgb"; # LG 27UP850 uses standard RGB
      #     lcdfilter = "light"; # "light" often better for 4K
      #   };
      #   hinting = {
      #     enable = true;
      #     style = "slight"; # "slight" usually better for high DPI
      #   };
      #   useEmbeddedBitmaps = true;
      # };
      # enableDefaultPackages = true;
      # enableGhostscriptFonts = true;
      packages = with pkgs; [
        corefonts # Microsoft core fonts for web compatibility
        liberation_ttf
        nerd-fonts.fira-code # Programming font with icons
        noto-fonts # Comprehensive Unicode support
        noto-fonts-cjk-sans # Support for Chinese, Japanese and Korean
        noto-fonts-emoji # Comprehensive Unicode support
        roboto # Google's Material Design font
        roboto-mono # Monospace version
      ];
    };

  };
}
