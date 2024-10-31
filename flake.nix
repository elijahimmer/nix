{
  description = "Elijah's Nixos Configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Flake helpers
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";

    # Common transitive dependencies
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    systems.url = "path:./systems.nix";
    systems.flake = false;

    # Secrets en/decryption
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.systems.follows = "systems";
    agenix.inputs.home-manager.follows = "home-manager";

    # User-level nix configuration
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Styling the nix way
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.systems.follows = "systems";
    stylix.inputs.flake-utils.follows = "flake-utils";
    stylix.inputs.home-manager.follows = "home-manager";

    # My Packages
    walrus-bar.url = "github:elijahimmer/walrus-bar";
    walrus-bar.inputs.nixpkgs.follows = "nixpkgs";
    walrus-bar.inputs.flake-utils.follows = "flake-utils";
    walrus-bar.inputs.systems.follows = "systems";

    zig-prompt.url = "github:elijahimmer/zig-prompt";
    zig-prompt.inputs.nixpkgs.follows = "nixpkgs";
    zig-prompt.inputs.flake-utils.follows = "flake-utils";
    zig-prompt.inputs.systems.follows = "systems";

    # Games
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.inputs.flake-parts.follows = "flake-parts";

    # Star Citizen
    nix-citizen.url = "github:LovingMelody/nix-citizen";
    nix-citizen.inputs.nixpkgs.follows = "nixpkgs";
    nix-citizen.inputs.systems.follows = "systems";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";
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
    in with pkgs; {
      formatter = alejandra;
      # Helps to bootstrap a new system
      devShells.default = mkShell {
        nativeBuildInputs = [
          git
          neovim
          ripgrep
          fd
          just
        ];
      };
    });
  in rec {
    inherit (generated) devShells formatter;
    nixosModules.default = import ./modules {inherit (nixpkgs) lib;};
    nixosConfigurations = let
      host = system: hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostName}/configuration.nix
            inputs.self.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.flake-utils-plus.nixosModules.autoGenFromInputs
          ];
          specialArgs = {
            inherit inputs system hostName;
            flakeAbsoluteDir = "/home/eimmer/src/nix";
            stateVersion = "24.11";
          };
        };
    in {
      gaea = host "x86_64-linux" "gaea";
      selene = host "x86_64-linux" "selene";
      helios = host "x86_64-linux" "helios";
      portable = host "x86_64-linux" "portable";
      pikvm = host "aarch64-linux" "pikvm";
    };
    images.pikvm = nixosConfigurations.pikvm.config.system.build.sdImage;
  };
}
