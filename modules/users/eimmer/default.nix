{
  lib,
  headless,
  ...
}: {
  imports = [] ++ lib.optional (!headless) ./desktop;

  home-manager.users.eimmer = {...}: {
    home = rec {
      username = "eimmer";
      homeDirectory = lib.mkDefault "/home/${username}";
    };

    home.stateVersion = "23.11";
  };
}
