{
  config,
  headFull,
  inputs,
  stateVersion,
  mods,
  ...
}: {
  imports =
    [
      ./env.nix
    ] ++
    (if headFull
    then [
      ./alacritty.nix
#      ./bar-rs.nix
      ./displayManager.nix
      ./firefox
      ./hyprland.nix
      ./packages.nix
      ./services.nix
      ./stylix.nix
      ./xdg.nix
    ]
    else []);

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

  services.openssh.hostKeys =
    [{ inherit (config.age.secrets.ssh) path; type = "ed25519"; }];

  users.users.eimmer = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.eimmer-passwd.path;
    openssh.authorizedKeys.keyFiles = mods.ssot.sshKeyfiles;
    extraGroups = ["wheel" "video" "networkmanager"];
    useDefaultShell = true;
  };
}
