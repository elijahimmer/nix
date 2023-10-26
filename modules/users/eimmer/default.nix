{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  home = rec {
    username = "eimmer";
    homeDirectory = "/home/${username}";
  };

  home.stateVersion = "23.11";
}
