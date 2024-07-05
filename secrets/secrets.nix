let
  desktop = [(builtins.readFile ../modules/ssot/ssh/desktop.pub)];
  gaea = [(builtins.readFile ../modules/ssot/ssh/server.pub)];
  lv14 = [(builtins.readFile ../modules/ssot/ssh/lv14.pub)];
  themAll = desktop ++ gaea ++ lv14;
in {
  "lv14-ssh.age".publicKeys = lv14;
  "desktop-ssh.age".publicKeys = desktop;
  "gaea-ssh.age".publicKeys = gaea;
  
  "eimmer-passwd.age".publicKeys = themAll;
}
