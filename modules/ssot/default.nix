{
  inputs,
  system,
  hostName,
  lib,
  config,
  ...
}:
with lib; {
  options.mein.ssot = {
    enable = mkEnableOption "enable secrets and the like" // {default = true;};
    age.enable = mkEnableOption "enable age secrets" // {default = config.mein.ssot.enable;};

    sshKeyFiles = mkOption {
      default = [
        ./ssh/helios.pub
        ./ssh/gaea.pub
        ./ssh/selene.pub
      ];
    };

    sshKeys = mkOption {
      default = {
        helios.publicKeyFile = ./ssh/helios.pub;
        gaea.publicKeyFile = ./ssh/gaea.pub;
        selene.publicKeyFile = ./ssh/selene.pub;
      };
    };
  };

  config = mkMerge [
    (mkIf config.mein.ssot.enable {services.openssh.knownHosts = config.mein.ssot.sshKeys;})
    (mkIf config.mein.ssot.age.enable {
      age = {
        identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        secrets = {
          ssh.file = inputs.self + /secrets/${hostName}-ssh.age;
          eimmer-passwd.file = inputs.self + /secrets/eimmer-passwd.age;
        };
      };
      environment.systemPackages = [inputs.agenix.packages.${system}.default];
    })
  ];
}
