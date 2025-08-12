{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
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
      size = 64 * 1024; # Creates an 64 GB swap file
    }
  ];

  # Enable hibernation for the swapfile
  boot.resumeDevice = "/dev/mapper/enc";

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

  # Kernel Parapmeters
  boot.kernelParams = [
    # Hibernation support
    "resume=/dev/mapper/enc"
    # You can find the correct off-set with
    # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
    "resume_offset=2981549" # Update with system specific number
  ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

}
