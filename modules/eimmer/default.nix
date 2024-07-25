{
  config,
  inputs,
  stateVersion,
  lib,
  ...
}: let
  cfg = config.mein.eimmer;
in
  with lib; {
    imports = [
      ./env.nix
      ./headFull
    ];

    options.mein.eimmer = {
      enable = (mkEnableOption "default user config") // {default = true;};
      sshAccess = (mkEnableOption "install authorized SSH keyfiles") // {default = true;};
      withEnv = mkEnableOption "use default environment" // {default = true;};
    };

    config = mkMerge [
      (mkIf cfg.enable {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs stateVersion;};
        };

        home-manager.users.eimmer = {stateVersion, ...}: {
          home = {inherit stateVersion;};
        };

        users.users.eimmer = {
          isNormalUser = true;
          hashedPasswordFile = lib.mkIf config.mein.ssot.age.enable config.age.secrets.eimmer-passwd.path;
          extraGroups = ["wheel" "video" "networkmanager"];
          useDefaultShell = true;
        };
      })
      (mkIf cfg.sshAccess {
        services.openssh.hostKeys = [
          {
            inherit (config.age.secrets.ssh) path;
            type = "ed25519";
          }
        ];
        users.users.eimmer.openssh.authorizedKeys.keyFiles = config.mein.ssot.sshKeyFiles;
      })
    ];
  }
