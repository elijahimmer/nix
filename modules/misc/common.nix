{
  pkgs,
  inputs,
  ...
}: {
  # just some default needed to make a system work. I will not use nano if avoidable.
  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  nix = {
    settings = {
      trusted-users = ["@wheel" "root"];
      auto-optimise-store = true;
      exprimental-features = ["nix-command" "flakes"];
    };

    package = pkgs.nixUnstable;

    extraOptions = let
      empty_registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
    in ''
      flake-registry = ${empty_registry}
      builders-use-substitutes = true
    '';
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    gc = {
      automatic = true;
      dates = "weekly";
    };
  };
}
