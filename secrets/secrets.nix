let
  lv14 = builtins.readFile ../../modules/ssot/lv14-ssh.pub;
  server = builtins.readFile ../../modules/ssot/server.pub;
  desktop = builtins.readFile ../../modules/ssot/desktop.pub;
  themAll = [lv14 server desktop];
in {
  "lv14-ssh.age".publicKeys = [lv14];
  "server-ssh.age".publicKeys = [server];
  "desktop-ssh.age".publicKeys = [desktop];
  "eimmer-passwd.age".publicKeys = themAll;
}
