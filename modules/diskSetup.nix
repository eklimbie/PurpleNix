{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  resumeDevice = "/dev/mapper/enc";
  swapSize = 64; # In GB
  # You can find the correct off-set with
  # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
  hibernateOffset = 8271112;
in
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
      size = swapSize * 1024; # Creates a swap file
    }
  ];

  # Enable hibernation for the swapfile
  boot.resumeDevice = resumeDevice;

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

  # Kernel Parameters
  boot.kernelParams = [
    "resume=${resumeDevice}"
    "resume_offset=${toString hibernateOffset}" # Update with system specific number
  ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

}
