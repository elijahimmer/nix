{
  inputs,
  system,
  hostName,
  ...
}: {
  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      ssh.file = inputs.self + /secrets/${hostName}-ssh.age;
      syncthing.file = inputs.self + /secrets/${hostName}-syncthing.age;
      eimmer-passwd.file = inputs.self + /secrets/eimmer-passwd.age;
    };
  };
  environment.systemPackages = [inputs.agenix.packages.${system}.default];
}
