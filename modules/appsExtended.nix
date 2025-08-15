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
    ## Installation of packages/software
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    ## Install apps via modules
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "ewout" ]; # Grant necessary system permissions to integrate with GNOME/system services.
    };
    programs.chromium.enable = true;
    programs.dconf.enable = true;
    programs.firefox.enable = true;
    programs.virt-manager.enable = true;

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [

      # CLI Applications and other tools
      apostrophe
      borgbackup
      ffmpeg-full
      flac
      ghostscript
      icloudpd
      imagemagickBig
      libheif
      rsgain
      virtiofsd

      # GUI Applications
      newsflash
      typora
    ];
    
  };
}
