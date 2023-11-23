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
    #agenix = {
    #  url = "github:ryantm/agenix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };
  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    stateVersion = "23.11";
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    nixosModules = import ./modules {lib = nixpkgs.lib;};
    nixosConfigurations = {
      lv14 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/lv14/configuration.nix

          inputs.utils.nixosModules.autoGenFromInputs
          home-manager.nixosModules.home-manager

          #agenix.nixosModules.age

          inputs.nixvim.nixosModules.nixvim
          inputs.stylix.nixosModules.stylix

          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-intel
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
        ];
        specialArgs = {
          inherit inputs stateVersion;
          hostName = "lv14";
          headless = false;
        };
      };
      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/server/configuration.nix

          inputs.utils.nixosModules.autoGenFromInputs
          home-manager.nixosModules.home-manager

          inputs.nixvim.nixosModules.nixvim
        ];
        specialArgs = {
          inherit inputs stateVersion;
          hostName = "server";
          headless = true;
        };
      };
    };
  };
}
