{...}: let
  lv14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtGu3F4RIogpoh5cai+8+kF6Ec8WJoM+1UfpmqPLB7v";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH0a9pghHok8USAlicO8tV1R11Uc/yt2nP0/O1D9rkme";
in {
  services.openssh.knownHosts = {
    lv14.publicKey = lv14;
    server.publicKey = server;
  };
}
