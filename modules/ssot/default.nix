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
    age.enable = mkEnableOption "enable age secrets" // {default = true;};

    sshKeyFiles = mkOption {
      default = [
        ./ssh/helios.pub
        ./ssh/gaea.pub
        ./ssh/selene.pub
      ];
    };

    sshKeys = mkOption {
      default = {
        helios.publicSshKeyFile = ./ssh/helios.pub;
        gaea.publicSshKeyFile = ./ssh/gaea.pub;
        selene.publicSshKeyFile = ./ssh/selene.pub;
      };
    };
  };

  config = mkIf config.mein.ssot.age.enable {
    age = {
      identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      secrets = {
        ssh.file = inputs.self + /secrets/${hostName}-ssh.age;
        eimmer-passwd.file = inputs.self + /secrets/eimmer-passwd.age;
      };
    };
    environment.systemPackages = [inputs.agenix.packages.${system}.default];
  };
}
