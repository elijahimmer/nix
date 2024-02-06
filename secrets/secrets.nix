let
  desktop = [(builtins.readFile ../modules/ssot/ssh/desktop.pub)];
  server = [(builtins.readFile ../modules/ssot/ssh/server.pub)];
  lv14 = [(builtins.readFile ../modules/ssot/ssh/lv14.pub)];
  themAll = desktop ++ server ++ lv14;
in {
  "lv14-ssh.age".publicKeys = lv14;
  "desktop-ssh.age".publicKeys = desktop;
  "server-ssh.age".publicKeys = server;
  
#  "lv14-syncthing.age".publicKeys = lv14;
  "desktop-syncthing.age".publicKeys = desktop;
#  "server-syncthing.age".publicKeys = server;
  
  "eimmer-passwd.age".publicKeys = themAll;
}
