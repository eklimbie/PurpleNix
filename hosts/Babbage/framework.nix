# This configuration file gives you everything you need to have your
# Framework 13 AI 300 Hardware fully recognised & up and running.

{
  ...
}:

{
  ##########
  ## Hardware set-up and config

  ## Enable power-optimisations
  # Basic config
  powerManagement.enable = true; # Basic NixOS set-up compatible with fancier stuff.
  powerManagement.powertop.enable = false; # Powertop will make everything laggy, keep turned off.
  networking.networkmanager.wifi.powersave = true; # Enable power-saving on wifi chip.

  # Enable AMD powermanagent
  services.power-profiles-daemon.enable = true; # works better with AMD tham TLP
  services.tlp.enable = false; # Disabled, conflicts with ppd


  ##########
  ## Network set-up
  # Define your host name.
  networking.hostName = "Babbage";

  ## Wifi
  # The Mediatek Chipset needs some additional config to make it work
  # https://community.frame.work/t/framework-laptop-13-amd-ryzen-ai-300-series-wireless-psa/68181
  # Load wireless regulatory database
  # hardware.wirelessRegulatoryDatabase = true;
  # Set country code (e.g., Germany)
  # boot.extraModprobeConfig = ''
  #   options cfg80211 ieee80211_regdom="DE"
  # '';
}