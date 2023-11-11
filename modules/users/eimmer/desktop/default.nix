{home-manager, ...}: {
  imports = [
    ./alacritty.nix
    ./displayManager.nix
    ./hyprland.nix
    ./music.nix
    ./programs.nix
    ./services.nix
    ./stylix.nix
  ];

  home-manager.users.eimmer = {...}: {
    programs.git = {
      enable = true;
      userEmail = "me@eimmer.me";
      userName = "Elijah M. Immer";
    };
  };
}
