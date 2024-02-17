_: let 
  group = "syncthing";
in {
  users.groups.${group} = {
    members = ["eimmer"];
  };
  services.syncthing = {
    inherit group;
    enable = true;

    openDefaultPorts = true;
    settings.options.urAccepted = -1;
  };
}
