{
  mods,
  hostName,
  config, 
  ...
}: let 
  group = "syncthing";
in {
  users.groups.${group} = {
    members = ["eimmer"];
  };
  services.syncthing = {
    inherit group;
    enable = true;
#    cert = toString mods.ssot.hosts.${hostName}.syncthing;
#    key = config.age.secrets.syncthing.path;

    openDefaultPorts = true;
    #settings.options = {
    #  urAccepted = -1;
    #};
  };
}
