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
    nixosConfigurations =
      let 
        stateVersion = "24.05";
        flakeAbsoluteDir = "/home/eimmer/src/nix";
        mods = inputs.self.nixosModules;
        commonModules = [
            inputs.home-manager.nixosModules.home-manager
            mods.common.default
            mods.env.default
            mods.eimmer.user
            mods.misc.networkmanager
            mods.ssot.age

            inputs.flake-utils-plus.nixosModules.autoGenFromInputs
            inputs.nixvim.nixosModules.nixvim
            inputs.agenix.nixosModules.default
 
            mods.env.coding
            mods.misc.tailscale
            mods.misc.syncthing
            mods.misc.mullvad
        ];
        headFullModules = with mods; [
          inputs.stylix.nixosModules.stylix
          theme.default
          misc.pipewire
        ];
      in {
      lv14 = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/lv14/configuration.nix

          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-intel
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
        ] ++ commonModules ++ headFullModules;
        specialArgs = {
          inherit inputs stateVersion system flakeAbsoluteDir mods;
          headFull = true;
          hostName = "lv14";
        };
      };
      desktop = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
         ./hosts/desktop/configuration.nix

          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
          inputs.nixos-hardware.nixosModules.common-gpu-amd
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
        ] ++ commonModules ++ headFullModules;
        specialArgs = {
          inherit inputs stateVersion system flakeAbsoluteDir mods; 
          headFull = true; 
          hostName = "desktop"; 
        };
      };
      server = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/server/configuration.nix

          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-amd
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-pc-hdd
        ] ++ commonModules;
        specialArgs = {
          inherit inputs stateVersion system flakeAbsoluteDir mods;
          headFull = false;
          hostName = "server";
        };
      };
/*      myPi = nixosSystem {
        hostName = "myPi";
        modules = [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"         
          {
            nixpkgs.config.allowUnsupportedSystem = true;
            nixpkgs.hostPlatform.system = "aarch64-linux";
            nixpkgs.buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.
            # ... extra configs as above
          }
        ];
      };*/
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

    images.myPi = self.nixosConfigurations.myPi.config.system.build.sdImage;
   #formatter = generated.formatter;
    devShells = generated.devShells;
  };
}
