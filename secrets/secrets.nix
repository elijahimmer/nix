let
  helios = [(builtins.readFile ../modules/ssot/ssh/helios.pub)];
  gaea = [(builtins.readFile ../modules/ssot/ssh/gaea.pub)];
  selene = [(builtins.readFile ../modules/ssot/ssh/selene.pub)];
  themAll = helios ++ gaea ++ selene;
in {
  "selene-ssh.age".publicKeys = selene;

  "gaea-ssh.age".publicKeys = gaea;

  "helios-ssh.age".publicKeys = helios;
  "helios-sonarr-token.age".publicKeys = helios;
  "helios-nginx-passwords.age".publicKeys = helios;

  "helios-ntfy-key.age".publicKeys = helios;

  "helios-grafana-password.age".publicKeys = helios;

  "eimmer-passwd.age".publicKeys = themAll;
}
