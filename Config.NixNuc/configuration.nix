# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:
# Set Variables
let
  # Remember to add the unstable channel to make this usuable
  # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  # You can check available channels with sudo nix-channel --list
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Include the optimisations specific to the machine.
    ./nixnuc-configuration.nix

    # NixOS has dedicated custom fixes for some hardware. You can enble that
    # by adding the hardware channel and then adding the specific device as a
    # module below
    # https://github.com/NixOS/nixos-hardware
    # <nixos-hardware/framework/13-inch/amd-ai-300-series>

    # Home Manager only works after you've added the channel to your install.
    # You may need to disable this in your initial install, for details go to
    # https://nix-community.github.io/home-manager/index.xhtml#ch-installation
    <home-manager/nixos> # Import Home Manger from channel
    ./home-manager.nix # Import Home Manager config
  ];

  ##########
  ## TPM and Security Configuration
  # Enable TPM 2.0 support
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true; # For PKCS#11 integration if needed later
    tctiEnvironment.enable = true; # For userspace TPM access
  };
  # Configure TPM tools to use kernel resource manager by default
  environment.sessionVariables = {
    TPM2TOOLS_TCTI = "device:/dev/tpmrm0";
  };

  # Enable systemd in initrd (REQUIRED for TPM unlocking)
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true; # Enables TPM2 support in systemd

  ##########
  ## Updated LUKS Configuration for TPM
  # Copy this over your existing boot.initrd.luks.devices."enc" in your hadware-configuration.nix:
  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-partlabel/system";
    # IMPORTANT: Always keep password fallback. Gives error if enabled, according to nixos-rebuild it is implied in my current config.
    # fallbackToPassword = true;
    # Allow discards for SSD performance
    allowDiscards = true;
  };

  ##########
  ## Set-up Filesystems
  # Set the correct mount options for all file systems as per https://wiki.nixos.org/wiki/Btrfs
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
    "/swap".options = [ "noatime" ];
  };

  # Create a swapfile https://wiki.nixos.org/wiki/Btrfs
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 64 * 1024; # Creates an 64GB swap file
    }
  ];

  # Set-up auto scrubbing (integrity checking) of btrfs
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [
      "/"
      "/home"
      "/nix"
      "/swap"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
      # configurationLimit = 10; # Keep only 10 boot entries to prevent boot partition from filling up.
    };
    efi.canTouchEfiVariables = true;
  };

  ##########
  ## Hardware set-up and config

  ## Yubikey login and sudo support
  # Make sure to create an authorisation mapping for your yubikey and add to
  # the home-manager config.
  services.pcscd.enable = true; # Enable smartcard (CCID) of Yubikey

  # Enable U2F PAM support
  security.pam.u2f = {
    enable = true;

    # Choose authentication mode:
    # "sufficient" = Yubikey OR password works
    # "required" = Yubikey AND password needed
    control = "sufficient";

    # Show "Please touch the device" message
    settings.cue = true;
  };

  # Enable U2F for specific services
  security.pam.services = {
    login.u2fAuth = false; # Physical TTY login
    sudo.u2fAuth = true; # Sudo commands
    polkit-1.u2fAuth = true; # GUI admin prompts
    gdm.u2fAuth = false; # For Gnome GDM login
    # gdm-password.u2fAuth = false; # Gnome GDM password service
    # gdm-fingerprint.u2fAuth = false; # Gnome GDM fingerprint
  };

  ##########
  ## Network Set-up
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  ## Enable Encrypted DNS
  # Enable systemd-resolved for DNS management
  services.resolved = {
    enable = true;
    dnsovertls = "true";
    dnssec = "false";

    # Configure local domain resolution
    extraConfig = ''
      [Resolve]
      DNS=193.110.81.0#dns0.eu
      DNS=2a0f:fc80::#dns0.eu
      DNS=185.253.5.0#dns0.eu
      DNS=2a0f:fc81::#dns0.eu
      # Allow local resolution to bypass encrypted DNS
      Domains=~. local
    '';
  };

  # Ensure NetworkManager doesn't override DNS settings
  networking.networkmanager.dns = "systemd-resolved";

  # Enable mDNS for .local domain resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Enable mDNS resolution via NSS
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };

  ##########
  ## Firewall set-up
  # Enable the firewall
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      #139   # SMB/CIFS
      #445   # SMB/CIFS
      51047 # Transmission
    ];
    allowedUDPPorts = [
      #137   # SMB/CIFS
      #138   # SMB/CIFS
      51047 # Transmission
    ];
    # Allow specific interfaces (useful for VMs, containers, or VPNs)
    trustedInterfaces = [
      "lo" # Always trust loopback interface
      "virbr0" # Uncomment if using libvirt/KVM
      # "docker0" # Uncomment if using Docker
    ];
    # Custom firewall rules using iptables syntax
    # These run before the automatic rules
    extraCommands = ''
      # Allow established and related connections (essential for normal operation)
      # Already enabled by NixOS by default.
      # iptables -A nixos-fw -m conntrack --ctstate ESTABLISHED,RELATED -j nixos-fw-accept

      # Allow local network discovery protocols
      # mDNS (Bonjour/Avahi) - for .local domain resolution
      iptables -A nixos-fw -p udp --dport 5353 -j nixos-fw-accept

      # DHCP client (if using DHCP to receive an IP address)
      iptables -A nixos-fw -p udp --sport 68 --dport 67 -j nixos-fw-accept

      # Optional: Allow SSDP for UPnP device discovery (printers, media servers)
      # iptables -A nixos-fw -p udp --dport 1900 -j nixos-fw-accept

      # Optional: Allow SMB/CIFS discovery if you access Windows shares
      # iptables -A nixos-fw -p udp --dport 137:138 -j nixos-fw-accept
      # iptables -A nixos-fw -p tcp --dport 139 -j nixos-fw-accept
      # iptables -A nixos-fw -p tcp --dport 445 -j nixos-fw-accept
    '';
  };

  ##########
  ## L18n Settings
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalization properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "nl_NL.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ]; # BEWARE: requires the added /UTF-8 at the end
    extraLocaleSettings = {
      # LC_ALL = "en_US.UTF-8"; # This overrides all other LC_* settings.
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

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
  ## Improve (font)redering for Electron apps by forcing wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

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

  ##########
  ## Setting up printing
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  ##########
  ## Enable sound with Pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touch-pad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  ##########
  ## User Set-up
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ewout = {
    isNormalUser = true;
    initialPassword = "ewout";
    description = "Ewout Klimbie";
    extraGroups = [
      "libvirtd" # Enable use of virtual machines
      "networkmanager" # Default
      # "tss" # Gives access to TPM devices without sudo
      "wheel" # Allows sudo
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  ##########
  ## Installation of packages/software
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Font configuration for better text rendering
  fonts = {
    fontconfig = {
      enable = true;
      # Hinting and subpixel fontconfig make text sharper in Gnome.
      subpixel = {
        rgba = "rgb"; # LG 27UP850 uses standard RGB
        lcdfilter = "light"; # "light" often better for 4K
      };
      hinting = {
        enable = true;
        style = "slight"; # "slight" usually better for high DPI
      };
    };
    packages = with pkgs; [
      corefonts # Microsoft core fonts for web compatibility
      inter # Modern alternative to inclusive-sans
      nerd-fonts.fira-code # Programming font with icons
      noto-fonts # Comprehensive Unicode support
      noto-fonts-emoji # Comprehensive Unicode support
      roboto # Google's Material Design font
      roboto-mono # Monospace version
    ];
  };

  ## Install apps via modules
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ewout" ]; # Grant necessary system permissions to integrate with GNOME/system services.
  };
  programs.chromium.enable = true;
  programs.dconf.enable = true;
  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.nano.enable = true;
  programs.virt-manager.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [

    # CLI Applications and other tools
    dconf2nix
    ffmpeg-full
    flac
    geekbench
    ghostscript
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_GB-large
    hunspellDicts.en_US-large
    hunspellDicts.nl_NL
    hyphenDicts.de_DE
    hyphenDicts.en_US
    imagemagickBig
    intel-gpu-tools # Intel Specific info about hardware
    libheif
    libnotify # Enables sending desktop notifications in custom services 
    nano
    nixd # Nix language server (LSP) for use in vscode
    nixfmt-rfc-style # Official formatter for Nix code
    p7zip
    pciutils # To get informaion about pci devices
    powertop
    rsgain
    speedtest-cli
    texliveFull
    tpm2-tools # For enrolling and managing TPM keys
    tpm2-tss # TPM Software Stack
    usbutils # To get information about usb devices
    wget
    yubikey-manager
    yt-dlp
    virtiofsd

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
    gnomeExtensions.caffeine
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.tiling-shell
    gnomeExtensions.vitals
    gnome-tweaks
    google-chrome
    gparted
    handbrake
    high-tide
    impression
    icloudpd
    unstable.joplin-desktop # fixes wayland issue on the 25.05 stable channel
    libreoffice-fresh
    makemkv
    newsflash
    obsidian
    picard
    plex-desktop
    protonvpn-gui
    resources
    signal-desktop
    sound-juicer
    soundconverter
    tor-browser
    transmission_4-gtk
    typora
    vlc
    vscode
    yubioath-flutter
    zed-editor

    # Things replacement candidates:
    planify
    todoist-electron
  ];

  ## 1Password Set-up
  # If it ever does not work, you can change these to "lib.mkForce false" to override NixOS priority setting.
  security.polkit.enable = true; # Polkit rules for 1Password (additional security integration)
  programs.ssh.startAgent = false; # Disable the default SSH agent, so that 1Password can provide its own

  # Keep GNOME keyring but exclude SSH component
  services.gnome.gnome-keyring.enable = true;
  # Override to disable only SSH agent component
  systemd.user.services.gnome-keyring-ssh = {
    enable = false;
  };

  # Resolve Gnome/KDE Plasma SSH askPassword conflicts
  # programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass"; # KDE/Plasma
  programs.ssh.askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass"; # Gnome

  # System-wide environment variable fallback
  environment.sessionVariables = {
    # SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
    SSH_ASKPASS_REQUIRE = "prefer"; # do explicit check if GUI is available.
  };

  # Disable GPG agent SSH support (conflicts with 1Password)
  programs.gnupg.agent.enableSSHSupport = false;

  ## Virt-manager set-up
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  ## Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ##########
  ## List services that you want to enable:

  # Enable Gnome services
  services.gnome = {
    gnome-browser-connector.enable = true;
  };

  # Enable the Linux fwupd service
  services.fwupd.enable = true;

  # Enable location service
  services.geoclue2.enable = true;

  # Enable Jotta
  services.jotta-cli = {
    enable = true;
    # options = [ ];
  };

  # Enable Input-remapper to easily change the mapping of your input device buttons
  services.input-remapper.enable = true;

  ##########
  ## NixOS Optimisation
  # Enable auto updating, but do not enable auto-reboot
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "daily";
    operation = "switch";
    persistent = true;
    randomizedDelaySec = "2hours";
  };
  # This setting will de-duplicate the nix store periodically, saving space
  nix.optimise = {
    automatic = true;
    persistent = true;
  };
  # This will automatically remove older no longer needed generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
    persistent = true;
  };

  # Enable SSH with secure configuration
  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = false; # Only allow key-based authentication
      KbdInteractiveAuthentication = false; # Disable keyboard-interactive auth
      PermitRootLogin = "no"; # Never allow root login via SSH
    };
  };

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
