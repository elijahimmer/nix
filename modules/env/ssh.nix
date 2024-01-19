{...}: let
  lv14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtGu3F4RIogpoh5cai+8+kF6Ec8WJoM+1UfpmqPLB7v";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3KnDxzYsl9MEb2h13Q35kWnsLrtu9oo8h4LTLN0SbY";
in {
  services.openssh.knownHosts = {
    lv14.publicKey = lv14;
    server.publicKey = server;
  };
}
