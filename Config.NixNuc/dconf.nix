# Based on dconf2nix: https://github.com/gvolpe/dconf2nix output.
# Not all settings can be succesfully for best results do not run it on "/" but on the specif path you want to save.
# for example: dconf dump /org/gnome/TextEditor/ | dconf2nix > dconf.nix

{ lib, ... }:

with lib.hm.gvariant; # Removes the need to use this prefix everytime

{
  dconf.settings = {
    "org/gnome/TextEditor" = {
      highlight-current-line = true;
      show-line-numbers = true;
      show-map = true;
    };

    "org/gnome/desktop/privacy" = {
      remove-old-temp-files = true;
      remove-old-trash-files = false;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/gnome-system-monitor" = {
      cpu-smooth-graph = true;
      cpu-stacked-area-chart = false;
      current-tab = "resources";
      logarithmic-scale = false;
      maximized = false;
      network-in-bits = false;
      network-total-in-bits = false;
      process-memory-in-iec = true;
      resources-memory-in-iec = true;
      show-all-fs = false;
      show-dependencies = true;
      show-whose-processes = "user";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "Vitals@CoreCoding.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "io.gitlab.news_flash.NewsFlash.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Calendar.desktop"
        "obsidian.desktop"
        "io.github.nokse22.HighTide.desktop"
        "code.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      welcome-dialog-last-shown-version = "48.1";
    };

    "org/gnome/shell/extensions/caffeine" = {
      duration-timer = 2;
      duration-timer-list = [
        900
        1800
        3600
      ];
      enable-fullscreen = true;
      enable-mpris = true;
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_processor_usage_"
        "_memory_usage_"
        "_system_load_5m_"
        "__network-rx_max__"
      ];
      icon-style = 1;
      memory-measurement = 0;
      menu-centered = false;
      storage-measurement = 0;
      storage-path = "/home";
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };
  };
}
