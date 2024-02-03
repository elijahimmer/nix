{
  description = "Elijah's Nixos Configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # For testing:
    #nixpkgs.url = "/home/eimmer/src/nixpkgs/";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My Packages
    bar-rs = {
      url = "github:elijahimmer/bar-rs";
      #url = "/home/eimmer/src/bar-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    nixosSystem = (self.nixosModules.custom.nixosSystem {inherit inputs;}).nixosSystem;
    generated = flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
#      formatter = pkgs.alejandra;
      # Helps to bootstrap a new system
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          git
          neovim
          ripgrep
          fd
          just
        ];
      };
    });
  in {
    nixosModules = import ./modules {lib = nixpkgs.lib;};
    nixosConfigurations = {
      lv14 = nixosSystem {
        hostName = "lv14";
        headFull = true;
        modules = [
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-intel
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
        ];
      };
      desktop = nixosSystem {
        hostName = "desktop";
        headFull = true;
        modules = [
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
          inputs.nixos-hardware.nixosModules.common-gpu-amd
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
      server = nixosSystem {
        hostName = "server";
        modules = [
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-amd
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-pc-hdd
        ];
      };
      # I don't want it to be checked unless I am going to use it because
      # It would be invalid, since it as no hardware config.
      /*
        minimal = nixosSystem {
        hostName = "minimal";
        headFull = false;
        useCommonExtendedModules = false;
      };
      */
    };
    #formatter = generated.formatter;
    devShells = generated.devShells;
  };
}
