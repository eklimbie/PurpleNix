# PurpleNix

A collection of scripts and configuration files for my NixOS machine(s). Currently in the process of moving to Flakes. The repo is a mess and a lot of hacks are used 😅.

## Flake Cheat Sheet

```sh
# Shows you all outputs the flake provides
nix flake show

# Shows you some basic data about your flake and all inputs it uses 
nix flake metadata

# Updates all inputs in your flake
nix flake update

# Build NixOS based on your flake, but does not enable it, nor does it add it to the boot menu
nixos-rebuild build --flake .#

# Build NixOS based on your flake and enables it, but doesn't add it to the boot menu
nixos-rebuild test --flake .#

# Build NixOS based on your flake, enables it, and adds it to the boot menu
nixos-rebuild switch --flake .#
```

## Further documentation

- [My Nixos Manual](documentation/nixos-manual.md)
- TPM Full Disk Encryption [Recovery Guide](documentation/nixos-tpm-recovery-guide.md)
- TPM Full Disk Encryption [Cheat Sheet](documentation/nixos-tpm-cheatsheet.md)
