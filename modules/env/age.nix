{
  inputs,
  system,
  config,
  ...
}: {
  age.identityPaths = ["/etc/ssh/lv14_ed25519_key"];
  age.secrets = {
    lv14-ssh.file = inputs.self + /secrets/lv14-ssh.age;
    eimmer-passwd.file = inputs.self + /secrets/eimmer-passwd.age;
  };
  environment.systemPackages = [inputs.agenix.packages.${system}.default];
}
