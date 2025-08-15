{
  # config,
  # lib,
  pkgs,
  # pkgsUnstable,
  ...
}:
let
  tpmDevice = "device:/dev/tpmrm0";
  luksDevice = "enc";
  luksPartition = "/dev/disk/by-partlabel/system";
in
{
  imports = [
  ];

  options = {
  };

  config = {

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
      TPM2TOOLS_TCTI = tpmDevice;
    };

    # Enable systemd in initrd (REQUIRED for TPM unlocking)
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.tpm2.enable = true; # Enables TPM2 support in systemd

    ##########
    ## Updated LUKS Configuration for TPM
    boot.initrd.luks.devices."${luksDevice}" = {
      device = luksPartition;
      # IMPORTANT: Always keep password fallback.
      # fallbackToPassword = true; # Gives error if enabled, according to nixos-rebuild it is implied in my current config.
      allowDiscards = true; # Allow discards for SSD performance
    };

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [
      tpm2-tools # For enrolling and managing TPM keys
      tpm2-tss # TPM Software Stack
    ];

  };
}
