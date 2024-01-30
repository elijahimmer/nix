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

  services.openssh = {
    hostKeys = [
      {
        path = config.age.secrets."${hostName}-ssh".path;
        type = "ed25519";
      }
    ];
  };

  users.users.eimmer = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.eimmer-passwd.path;
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/ssh-public-keys/lv14.pub
      ../../secrets/ssh-public-keys/server.pub
      ../../secrets/ssh-public-keys/desktop.pub
    ];
    extraGroups = ["wheel" "video" "networkmanager"];
    useDefaultShell = true;
  };
}
