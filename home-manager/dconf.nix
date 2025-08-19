# Based on dconf2nix: https://github.com/gvolpe/dconf2nix output.
# Not all settings can be succesfully for best results do not run it on "/" but on the specif path you want to save.
# for example: dconf dump /org/gnome/settings-daemon/plugins/media-keys/ | dconf2nix > dconfdump.nix

{ lib, ... }:

with lib.hm.gvariant; # Removes the need to use this prefix everytime

{
  dconf.settings = {
    "it/mijorus/smile" = {
      emoji-size-class = "emoji-button";
      iconify-on-esc = false;
      last-run-version = "2.10.1";
      load-hidden-on-startup = true;
      mouse-multi-select = true;
      use-localized-tags = true;
      tags-locale = "nl";
    };
    "org/gnome/TextEditor" = {
      highlight-current-line = true;
      show-line-numbers = true;
      show-map = true;
    };

    "org/gnome/desktop/privacy" = {
      remove-old-temp-files = true;
      remove-old-trash-files = false;
    };

    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
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
      night-light-enabled = false;
      night-light-schedule-automatic = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "kgx";
      name = "Open Console";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Control><Super>space";
      command = "smile";
      name = "EmojiPicker";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "Vitals@CoreCoding.com"
        "nightthemeswitcher@romainvigier.fr"
        "smile-extension@mijorus.it"
      ];
      favorite-apps = [
        "firefox.desktop"
        # "io.gitlab.news_flash.NewsFlash.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Calendar.desktop"
        "todoist.desktop"
        "obsidian.desktop"
        "signal.desktop"
        "io.github.nokse22.HighTide.desktop"
        "io.github.nokse22.high-tide.desktop"
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

    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      manual-schedule = false;
    };

    "org/gnome/shell/extensions/vitals" = {
      battery-slot = 1;
      fixed-widths = false;
      hot-sensors = [
        "_processor_usage_"
        "_memory_usage_"
        "_system_load_5m_"
        "__network-rx_max__"
      ];
      icon-style = 1;
      include-static-gpu-info = false;
      memory-measurement = 0;
      menu-centered = false;
      monitor-cmd = "resources";
      show-battery = true;
      show-gpu = true;
      show-system = true;
      storage-measurement = 0;
      storage-path = "/home";
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = false;
    };
  };
}
