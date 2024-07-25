{
  description = "Elijah's Nixos Configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My Packages
    wlrs-bar = {
      url = "github:elijahimmer/wlrs-bar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # starcitizen
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    ...
  } @ inputs: let
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
    inherit (generated) devShells;
    nixosModules = import ./modules {inherit (nixpkgs) lib;};
    nixosConfigurations = let
      stateVersion = "24.11";
      flakeAbsoluteDir = "/home/eimmer/src/nix";
      pkgs-stable = nixpkgs-stable.legacyPackages;
      commonModules = hostname: [
        ./hosts/${hostname}/configuration.nix
        inputs.self.nixosModules
        inputs.home-manager.nixosModules.home-manager
        inputs.flake-utils-plus.nixosModules.autoGenFromInputs
        inputs.agenix.nixosModules.default
      ];
    in {
      gaea = inputs.nixpkgs.lib.nixosSystem (let
        hostName = "gaea";
      in rec {
        system = "x86_64-linux";
        modules = commonModules hostName;
        specialArgs = {
          inherit inputs stateVersion system flakeAbsoluteDir hostName;
          pkgs-stable = pkgs-stable.${system};
        };
      });
      #selene = inputs.nixpkgs.lib.nixosSystem (let hostName = "selene"; in rec {
      #  system = "x86_64-linux";
      #  modules =
      #    [
      #      inputs.nixos-hardware.nixosModules.common-cpu-intel
      #      #inputs.nixos-hardware.nixosModules.common-gpu-intel
      #      inputs.nixos-hardware.nixosModules.common-pc-laptop
      #      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      #    ] ++ commonModules hostName;
      #  specialArgs = {
      #    inherit inputs stateVersion system flakeAbsoluteDir hostName;
      #    pkgs-stable = pkgs-stable.${system};
      #  };
      #});
      #helios = inputs.nixpkgs.lib.nixosSystem (let hostName = "helios"; in rec {
      #  system = "x86_64-linux";
      #  modules =
      #    [
      #      inputs.nixos-hardware.nixosModules.common-cpu-intel
      #      inputs.nixos-hardware.nixosModules.common-gpu-amd
      #      inputs.nixos-hardware.nixosModules.common-pc
      #      inputs.nixos-hardware.nixosModules.common-pc-ssd
      #    ] ++ commonModules hostName;
      #  specialArgs = {
      #    inherit inputs stateVersion system flakeAbsoluteDir hostName;
      #    pkgs-stable = pkgs-stable.${system};
      #  };
      #});
    };
  };
}
