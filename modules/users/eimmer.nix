{
  config,
  headfull,
  hostName,
  inputs,
  stateVersion,
  lib,
  ...
}: {
  imports = [] ++ lib.optional headfull ./eimmer-desktop;

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

  services.openssh.hostKeys = [
    {
      path = config.age.secrets."${hostName}-ssh".file;
      type = "ed25519";
    }
  ];

  users.users.eimmer = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.eimmer-passwd.path;
    openssh.authorizedKeys.keys = "";
    extraGroups = ["wheel" "video" "networkmanager"];
    useDefaultShell = true;
  };
}
