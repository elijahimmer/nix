{
  description = "Elijah's Nixos Configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

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
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim
    lz-n = {
      url = "github:nvim-neorocks/lz.n";
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
      formatter = pkgs.alejandra;
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
    inherit (generated) devShells formatter;
    nixosModules = import ./modules {inherit (nixpkgs) lib;};
    nixosConfigurations = let
      host = system: hostName:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostName}/configuration.nix
            inputs.self.nixosModules
            inputs.home-manager.nixosModules.home-manager
            inputs.flake-utils-plus.nixosModules.autoGenFromInputs
          ];
          specialArgs = {
            inherit inputs system hostName;
            pkgs-stable = nixpkgs-stable.legacyPackages.${system};
            flakeAbsoluteDir = "/home/eimmer/src/nix";
            stateVersion = "24.11";
          };
        };
    in {
      gaea = host "x86_64-linux" "gaea";
      selene = host "x86_64-linux" "selene";
      helios = host "x86_64-linux" "helios";
      portable = host "x86_64-linux" "portable";
    };
  };
}
