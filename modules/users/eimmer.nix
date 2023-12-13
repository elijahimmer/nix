{
  home-manager,
  config,
  inputs,
  headless,
  stateVersion,
  lib,
  ...
}: {
  imports = [] ++ lib.optional (!headless) ./eimmer-desktop;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs stateVersion;};
  };
  programs.git = {
    enable = true;
    config = {
      core.editor = "nvim";
      user = {
        Email = "me@eimmer.me";
        Name = "Elijah M. Immer";
      };
    };
  };
  home-manager.users.eimmer = {stateVersion, ...}: {
    home = {inherit stateVersion;};
  };

  users.users.eimmer = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$6Plp2pMTkOghQgFYm7bav/$AOKB9bEhkSk22Jdacq6cpP0kWu7ad35DhmgHJnJCE98";
    extraGroups = ["wheel" "video" "networkmanager"];
  };
}
