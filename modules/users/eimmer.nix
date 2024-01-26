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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtGu3F4RIogpoh5cai+8+kF6Ec8WJoM+1UfpmqPLB7v eimmer@lv14"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH0a9pghHok8USAlicO8tV1R11Uc/yt2nP0/O1D9rkme eimmer@server"
    ];
    extraGroups = ["wheel" "video" "networkmanager"];
    useDefaultShell = true;
  };
}
