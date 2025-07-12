# This file contains all home-manager related configuration. This is to easily
# enable you to rebuild the system without home-manager.
# https://wiki.nixos.org/wiki/Home_Manager
# https://nix-community.github.io/home-manager/index.xhtml

{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
# Set Variables
let
  onePassPath = "~/.1password/agent.sock";
in
{
  # Config of Home Manager
  home-manager.useGlobalPkgs = true;

  # User Config
  home-manager.users.ewout =
    { pkgs, ... }:
    {
      # import subfiles
      imports = [ ./dconf.nix ]; # Gnome saved settings

      # Your Home Manager configuration
      home.packages = with pkgs; [
        _1password-cli
        _1password-gui
      ];

      ##########
      ## 1Password Set-up
      # Configure bash to export SSH_AUTH_SOCK
      programs.bash = {
        enable = true;
        initExtra = ''
          # Export 1Password SSH agent socket for all interactive bash sessions
          export SSH_AUTH_SOCK="${onePassPath}"
        '';
      };

      # Environment variable as backup
      home.sessionVariables = {
        SSH_AUTH_SOCK = "${onePassPath}";
      };

      # SSH Set-up for 1Password
      programs.ssh = {
        enable = true;
        extraConfig = ''
          Host *
            IdentityAgent ${onePassPath}
            AddKeysToAgent yes
        '';
      };

      # Git set-up for SSH signing
      programs.git = {
        enable = true;
        userName = "Ewout Klimbie";
        # You can find the right email address here: https://github.com/settings/emails
        userEmail = "90047337+eklimbie@users.noreply.github.com";
        extraConfig = {
          gpg = {
            format = "ssh";
            ssh = {
              program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
              allowedSignersFile = "/home/ewout/.ssh/allowed_signers";
            };
          };
          commit = {
            gpgsign = true;
          };
          user = {
            # Github Public Signing
            signingKey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/4AMKL3PIKr1GLOlR44L85uuY+JmGVt15KOom0BipJ";
          };
          # URL rewriting - automatically use SSH instead of https for GitHub
          url = {
            "git@github.com:" = {
              insteadOf = "https://github.com/";
            };
          };
        };
      };

      # Create the allowed signers file
      # You can find the right email address here: https://github.com/settings/emails
      home.file.".ssh/allowed_signers".text = ''
        90047337+eklimbie@users.noreply.github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/4AMKL3PIKr1GLOlR44L85uuY+JmGVt15KOom0BipJ
      '';

      ##########
      ## Autostart applications
      systemd.user.services = {
        # Automatically start input-remapper so that it works if I set-up a config
        input-remapper-autostart = {
          Unit = {
            Description = "Input Remapper Autostart";
            After = [ "graphical-session.target" ];
            Wants = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
            Restart = "on-failure";
            RestartSec = 5;
            StartLimitBurst = 5; # Only try 5 restarts...
            StartLimitIntervalSec = 30; # ...within 30 seconds, then give up
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
        # Ensure that 1Password is always loaded.
        onePassword-autostart = {
          Unit = {
            description = "1Password Autostart";
            After = [ "graphical-session.target" ];
            Wants = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
            Restart = "on-failure";
            RestartSec = 5;
            StartLimitBurst = 5; # Only try 5 restarts...
            StartLimitIntervalSec = 30; # ...within 30 seconds, then give up
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
      };

      # yt-dlp config
      programs.yt-dlp.enable = true;
      programs.yt-dlp.settings = {
        path = "~/Downloads";
        cookies-from-browser = "firefox";
        # Youtube is crackinf down on yt-dlp, some settings are needed to enable
        # download of all formats.
        # https://github.com/yt-dlp/yt-dlp/issues/12482
        # https://github.com/yt-dlp/yt-dlp/wiki/PO-Token-Guide
        extractor-args = "youtube:player-client=default,mweb;po_token=mweb.gvs+MnRtN_J22ERVHG0P67HmTxXX_WHgCXHSC_jsphCkKlXUB4ybwtFnYpAOas9yN_-FbkDwBD0D7eGvPUpOfiiCt9sAdo-pK7721oiWRC60Nb4cWyOdQXZx0FQToJZpYxFKZDJPZ4Ufte23Ag1Wwh7LvTDzTqfVsw==";
        embed-subs = true;
        embed-thumbnail = true;
        embed-metadata = true;
        embed-chapters = true;
      };

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "25.05";
    };
}
