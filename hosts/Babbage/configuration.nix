# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  # config,
  # lib,
  # pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable flake support
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ## Enable power-optimisations
  # Basic config
  powerManagement.enable = true; # Basic NixOS set-up compatible with fancier stuff.
  powerManagement.powertop.enable = false; # Powertop will make everything laggy, keep turned off.
  networking.networkmanager.wifi.powersave = true; # Enable power-saving on wifi chip.

  # Enable AMD powermanagent
  services.power-profiles-daemon.enable = true; # works better with AMD tham TLP
  services.tlp.enable = false; # Disabled, conflicts with ppd

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "auto";
      memtest86.enable = true;
      # configurationLimit = 10; # Keep only 10 boot entries to prevent boot partition from filling up.
    };
    efi.canTouchEfiVariables = true;
  };

  ##########
  ## Set-up Filesystems
  # Set the correct mount options for all file systems as per https://wiki.nixos.org/wiki/Btrfs
  # fileSystems = {
  #   "/".options = [ "compress=zstd" ];
  #   "/home".options = [ "compress=zstd" ];
  #   "/nix".options = [
  #     "compress=zstd"
  #     "noatime"
  #   ];
  #   "/swap".options = [ "noatime" ];
  # };
# 
  # # Create a swapfile https://wiki.nixos.org/wiki/Btrfs
  # swapDevices = [
  #   {
  #     device = "/swap/swapfile";
  #     size = 64 * 1024; # Creates an 64 GB swap file
  #   }
  # ];
# 
  # # Enable hibernation for the swapfile
  # boot.resumeDevice = "/dev/mapper/enc";
# 
  # boot.kernelParams = [
  #   # Hibernation support
  #   "resume=/dev/mapper/enc"
  #   # You can find the correct off-set with
  #   # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
  #   "resume_offset=8271112" # Update with system specific number
  # ];
# 
  # # Set-up auto scrubbing (integrity checking) of btrfs
  # services.btrfs.autoScrub = {
  #   enable = true;
  #   interval = "weekly";
  #   fileSystems = [
  #     "/"
  #     "/home"
  #     "/nix"
  #     "/swap"
  #   ];
  # };

  networking.hostName = "Babbage"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.ewout = {
  #   isNormalUser = true;
  #   initialPassword = "ewout";
  #   description = "Ewout Klimbie";
  #   extraGroups = [
  #     "libvirtd" # Enable use of virtual machines
  #     "networkmanager" # Default
  #     # "tss" # Gives access to TPM devices without sudo
  #     "wheel" # Allows sudo
  #   ];
  #   packages = with pkgs; [
  #     #  thunderbird
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
