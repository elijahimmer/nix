{
  pkgs,
  inputs,
  hostName,
  stateVersion,
  ...
}: {
  # just some default needed to make a system work. I will not use nano if avoidable.
  environment.systemPackages = with pkgs; [git];
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = ["@wheel" "root"];
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8 days";
      persistent = true;
    };

    daemonIOSchedClass = "best-effort";
    daemonCPUSchedPolicy = "batch";

    package = pkgs.nixUnstable;

    extraOptions = let
      empty_registry =
        builtins.toFile "empty-flake-registry.json"
        ''{"flakes":[],"version":2}'';
    in ''
      flake-registry = ${empty_registry}
      builders-use-substitutes = true
    '';
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  networking = {inherit hostName;};
  system = {inherit stateVersion;};
}
