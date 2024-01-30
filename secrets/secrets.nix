let
  lv14 = builtins.readFile ./ssh-public-keys/lv14-ssh.pub;
  server = builtins.readFile ./ssh-public-keys/server.pub;
  desktop = builtins.readFile ./ssh-public-keys/desktop.pub;
  themAll = [lv14 server desktop];
in {
  "lv14-ssh.age".publicKeys = [lv14];
  "server-ssh.age".publicKeys = [server];
  "desktop-ssh.age".publicKeys = [desktop];
  "eimmer-passwd.age".publicKeys = themAll;
}
