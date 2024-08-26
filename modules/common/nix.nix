{
  lib,
  inputs,
  config,
  flakeAbsoluteDir,
  ...
}: {
  options.mein.common.nix.enable = lib.mkEnableOption "enable default nix package config" // {default = true;};

  config = lib.mkIf config.mein.common.nix.enable {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      })
    ];

    nix = {
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
      settings = {
        trusted-users = ["@wheel" "root"];
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 8d";
        persistent = true;
      };
      daemonIOSchedClass = "best-effort";
      daemonCPUSchedPolicy = "batch";
    };

    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      flake = "github:elijahimmer/nix";
      fixedRandomDelay = true;
      allowReboot = true;
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
    };
  };
}
