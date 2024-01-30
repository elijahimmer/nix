{...}: let
  user = "builder";
  uid = 999;
  group = "nix-builder";
  gid = 999;
in {
  nix.settings.trusted-users = [user];
  users.users.${user} = {
    inherit group uid;
    isSystemUser = true;
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/ssh-public-keys/lv14.pub
      ../../secrets/ssh-public-keys/server.pub
      ../../secrets/ssh-public-keys/desktop.pub
    ];
  };
  users.groups.nix-builder = {inherit gid;};
}
