{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
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
      # LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      # LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      # LC_TIME = "en_GB.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };

}
