{
  description = "Flake for setting up Ewout Klimbie's systems with NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        NixNuc = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgsUnstable; };
          modules = [
            # { nixpkgs.overlays = [ overlay-unstable ]; }
            ./hosts/NixNuc/configuration.nix
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ewout = ./home-manager/home.nix;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };
        Babbage = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgsUnstable; };
          modules = [
            { nixpkgs.config.allowUnfree = true; } # Allow unfree apps in all modules
            ./hosts/Babbage/configuration.nix
            ./modules/nixOSOptimisation.nix
            ./modules/tpmLuksUnlock.nix
            ./modules/secureDNS.nix
            ./modules/firewall.nix
            ./modules/inputDevices.nix
            ./modules/l18n.nix
            ./modules/gnome.nix
            ./modules/appsCoreCLI.nix
            ./modules/appsCoreDesktop.nix
            ./modules/onePassword.nix
            ./modules/user.nix
            ./modules/fonts.nix
            ./modules/sound.nix
            ./modules/diskSetup.nix
            ./modules/yubikey.nix
            # Add a NixOS module to optimize settings for your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
            nixos-hardware.nixosModules.framework-amd-ai-300-series
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ewout = ./home-manager/laptopHome.nix;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };
      };
    };
}
