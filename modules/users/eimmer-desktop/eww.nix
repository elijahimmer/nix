{...}: {
  home-manager.users.eimmer = {
    pkgs,
    lib,
    ...
  }: {
    programs.eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./eww;
    };
  };
}
