{
  description = "Elijah's Nixos Configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # For testing:
    #nixpkgs.url = "/home/eimmer/src/nixpkgs/";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My Packages
    bar-rs = {
      url = "github:elijahimmer/bar-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    stateVersion = "24.05";
    flakeAbsoluteDir = "/home/eimmer/src/nix";
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    nixosModules = import ./modules {lib = nixpkgs.lib;};
    nixosConfigurations = {
      lv14 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/lv14/configuration.nix

          inputs.utils.nixosModules.autoGenFromInputs
          inputs.home-manager.nixosModules.home-manager

          inputs.nixvim.nixosModules.nixvim
          inputs.stylix.nixosModules.stylix
          inputs.agenix.nixosModules.default

          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-intel
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
        ];
        specialArgs = {
          inherit inputs stateVersion system flakeAbsoluteDir;
          hostName = "lv14";
          headfull = true;
        };
      };
      server = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/server/configuration.nix

          inputs.utils.nixosModules.autoGenFromInputs
          inputs.home-manager.nixosModules.home-manager

          inputs.nixvim.nixosModules.nixvim
          inputs.agenix.nixosModules.default
        ];
        specialArgs = {
          inherit inputs stateVersion system;
          hostName = "server";
          headfull = false;
        };
      };
    };
  };
}
