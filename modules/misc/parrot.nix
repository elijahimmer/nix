{pkgs,...}:
{

  systemd.services.parrot = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
  };
}
