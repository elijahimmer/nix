{...}: let group = "syncthing"; in {
  users.groups.${group} = {
    members = ["eimmer"];
  };
  services.syncthing = {
    inherit group;
    enable = true;
    settings.options.urAccepted = -1;
    /*folders = {
      "/home/eimmer/sync" = {};
    };*/
  };
}
