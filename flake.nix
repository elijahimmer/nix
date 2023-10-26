{
  description = "Elijah's Nixos Configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
    };
  };
  outputs = {
    self,
    home-manager,
    nixpkgs,
    agenix,
    nixos-hardware,
    utils,
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    nixosModules = import ./modules {lib = nixpkgs.lib;};
    nixosConfigurations = {
      lv14 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/lv14/configuration.nix

          utils.nixosModules.autoGenFromInputs
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age

          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.common-pc-laptop
          nixos-hardware.nixosModules.common-pc-laptop-ssd
        ];
        specialArgs = {
          inherit inputs;
          hostname = "lv14";
        };
      };
    };
  };
}
