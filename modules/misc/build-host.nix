{mods, ...}: let
  user = "builder";
  uid = 999;
  group = "nix-builder";
  gid = 999;
in {
  nix.settings.trusted-users = [user];
  users.users.${user} = {
    inherit group uid;
    isSystemUser = true;
    openssh.authorizedKeys.keyFiles = mods.ssot.keyFiles;
  };
  users.groups.nix-builder = {inherit gid;};
}
