{...}: let
  user = "builder";
in {
  nix.settings.trusted-users = [user];
  users.users.${user} = {
    isSystemUser = true;
    openssh.authorizedKeys.keyFiles = [
      (builtins.readFile ../../secrets/ssh-public-keys/lv14.pub)
      (builtins.readFile ../../secrets/ssh-public-keys/server.pub)
      (builtins.readFile ../../secrets/ssh-public-keys/desktop.pub)
    ];
  };
}
