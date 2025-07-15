# This configuration file gives you everything you need to have all your
# hardware supported and working well.

{
  pkgs,
  ...
}:

{
  ##########
  ## Network set-up
  networking.hostName = "NixNuc"; # Define your host name.
  
  ##########
  ## Hardware set-up and config
  # Enable intel QuickSync for hardware video decoding
  hardware.graphics = {
    enable = true; # Usually already enabled by DE
    extraPackages = with pkgs; [
      # your Open GL, Vulkan and VAAPI drivers
      intel-media-driver # Correct driver for anything broadwell (Core i 5xxx) or later
      intel-vaapi-driver # Fallback for older hardware
    ];
  };

  ## Enable power-optimisations
  # Basic config
  powerManagement.enable = true; # Basic NixOS set-up compatible with fancier stuff.
  powerManagement.powertop.enable = false; # Powertop will make everything laggy, keep turned off.
  networking.networkmanager.wifi.powersave = true; # Enable power-saving on wifi chip.

  # Intel specific tweaks
  services.thermald.enable = true; # Proactively prevents overheating on Intel CPUs and works well with other tools.
  boot.kernelParams = [
    # Intel P-State configuration
    "intel_pstate=active" # Use Intel's hardware frequency control
    # Intel graphics power management
    "i915.enable_rc6=1" # Enable render context 6 (deepest GPU sleep)
    "i915.enable_fbc=1" # Enable framebuffer compression
    "i915.enable_psr=1" # Enable panel self refresh
    # CPU power management
    "intel_idle.max_cstate=9" # Allow deepest CPU sleep states
    #"processor.max_cstate=9"         # Alternative C-state setting for compatibility
  ];

  # Enable TLP
  services.power-profiles-daemon.enable = false; # needs to be disabled for tlp to function
  services.tlp = {
    enable = true;
    settings = {
      DISK_DEVICES = "nvme0n1";

      AHCI_RUNTIME_PM_ON_AC = "auto";
      NMI_WATCHDOG = 0;

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_AC = 1;

      # Network power management - automatic WiFi/LAN switching
      #DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
      #DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi";

      RUNTIME_PM_ON_AC = "auto";

      # Comprehensive USB input device protection
      USB_EXCLUDE_HID = 1; # Covers most input devices
      USB_EXCLUDE_HUB = 1; # Prevents hub disconnections
      USB_EXCLUDE_BTUSB = 1; # Bluetooth adapters
      USB_EXCLUDE_PHONE = 1; # Mobile devices

      # Specific devices that might not be covered by HID
      # USB_DENYLIST = "046d:c547 046d:c548"; # Logitech USB dongles
    };
  };
  # Workaround for Intel Ethernet I225-V disappearing after suspend.
  # The solution is to restart the driver, as per: https://askubuntu.com/questions/1545459/network-interface-disappears-after-suspend-on-ubuntu-24-04-with-intel-igc-driver
  systemd.services.igc-enable = {
    description = "Reload the Intel Ethernet I225-V kernel mod after suspend, to fix issue with tlp.";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    script = ''
      /run/current-system/sw/bin/modprobe -r igc
      /run/current-system/sw/bin/modprobe igc
    '';
    serviceConfig.Type = "oneshot";
  };

}
