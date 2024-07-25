{lib, ...}: {
  imports = [
    ./alacritty.nix
    ./displayManager.nix
    ./firefox
    ./hyprland.nix
    ./services.nix
    ./theme.nix
    ./packages.nix
    ./xdg.nix
  ];

  options.mein.eimmer.headFull.enable = lib.mkEnableOption "install GUI tools and environments";
}
