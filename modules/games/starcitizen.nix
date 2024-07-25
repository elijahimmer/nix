{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib; {
  imports = [inputs.nix-citizen.nixosModules.StarCitizen];

  options.mein.games.starCitizen.enable = mkEnableOption "enable gaming configurations";

  config = mkIf config.mein.games.starCitizen.enable {
    networking.extraHosts = "127.0.0.1 modules-cdn.eac-prod.on.epicgames.com"; # disable easy anti-cheat

    nix.settings = {
      # add nix cache
      substituters = ["https://nix-citizen.cachix.org" "https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };

    environment.systemPackages = with pkgs; [
      mono
      inputs.nix-citizen.packages.${system}.star-citizen
    ];

    nix-citizen.starCitizen.enable = true;
  };
}
