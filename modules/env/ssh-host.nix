{
  lib,
  config,
  ...
}: {
  options.mein.sshHost.enable = lib.mkEnableOption "enable the ssh daemon";

  config = lib.mkIf config.mein.sshHost.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkForce "no";
      };

      openFirewall = lib.mkForce true;
    };
  };
}
