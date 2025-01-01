let
  helios = [(builtins.readFile ../modules/ssot/ssh/helios.pub)];
  gaea = [(builtins.readFile ../modules/ssot/ssh/gaea.pub)];
  selene = [(builtins.readFile ../modules/ssot/ssh/selene.pub)];
  themAll = helios ++ gaea ++ selene;
in {
  "selene-ssh.age".publicKeys = selene;

  "gaea-ssh.age".publicKeys = gaea;

  "helios-ssh.age".publicKeys = helios;
  "helios-nginx-passwords.age".publicKeys = helios;

  "helios-influxdb2-password.age".publicKeys = helios;
  "helios-influxdb2-admin-token.age".publicKeys = helios;

  "helios-influxdb2-grafana-token.age".publicKeys = helios;
  "helios-influxdb2-telegraf-token.age".publicKeys = helios;

  "helios-telegraf-environment.age".publicKeys = helios;

  "helios-grafana-password.age".publicKeys = helios;

  "eimmer-passwd.age".publicKeys = themAll;
}
